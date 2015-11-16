load "connection_setup.rb"
load "pubnub_node.rb"
load "backend_client.rb"
load "emu_logger.rb"
require "set"
require "thread"

module NightlightEmulator
  # NightlightEmulator core class. It represent Nightlight device donnected to the network.
  # After initialized it should behave as connected device.
  # Internally Device will runs separate thread that listen PubNub, Backend messages and respond to them as device would.
  # There may be multiple Device classes created simultaneously, but they should have different ids, tokens etc. (as real devices).
  class Device
    # Interval between stream messages (in seconds).
    STREAMING_INTERVAL = 15
    # Interval between readings posts (in seconds).
    READINGS_INTERVAL = 900 # 15 min.
    # Amount of time for which ALS is suspended (in seconds).
    SUSPEND_TIMEOUT = 120 # 2 min.
    # Amount of time for which new alarms are ignored after dismiss-danger
    COOL_DOWN_TIMEOUT = 120 # 2 min.
    
    # Initialize method replace BLE setup from real world and defines initial peripherels state.
    # New device is disabled by default.
    # Params:
    # +connection+:: +ConnectionSetup+ object with clound connection parameters.
    # +devInfo+:: +DeviceInfo+ object with device parameters.
    # +devState+:: +DeviceState+ object with peripherals state parameters.
    # +alarms+:: +DeviceAlarms+ object with alarms states.
    def initialize(connection, devInfo, devState, alarms = nil)
      @connection = connection.clone
      @devInfo = devInfo.clone
      @devState = devState.clone
      @alarms = alarms.nil? ? DeviceAlarms.new : alarms.clone
      @enabled = false
      @mainLock = Mutex.new
      @dataLock = Mutex.new
      @pubNubNode = PubNubNode.new(@connection.publishKey, @connection.subscribeKey, @connection.origin, self)
      @backendClient = BackendClient.new(@connection.backend, @devInfo.token)
      @changeListenrs = Set.new
      
      @streamLock = Mutex.new
      @streamCond = ConditionVariable.new
      @streaming = false

      @readingsLock = Mutex.new
      @readingsCond = ConditionVariable.new

      @suspendLock = Mutex.new
      @suspendCond = ConditionVariable.new
      
      @skipLock = Mutex.new
    end
    
    # Add +Proc+ that will be called on each device change (info or state).
    # Params:
    # +listener+:: +Proc+ object.
    def addListener(listener)
      @mainLock.synchronize {
        @changeListenrs << listener
      }
    end
    
    # Removes +Proc+ from listeners set.
    # Params:
    # +listener+:: +Proc+ object.
    def removeListener(listener)
      @mainLock.synchronize {
        @changeListenrs.delete(listener)
      }
    end

    # Emulates turning device on.
    # Connect to PubNub channel and send info-connected.
    def enable
      @mainLock.synchronize {
        if !enabled?
          $LOG.info("Enabling device #{@devInfo.serialNb}.")
          @backendClient.putDeviceInfo(@devInfo)
          changed = @backendClient.getDeviceState(@devInfo, @devState)
                  
          @pubNubNode.connect(@devInfo.channel)
          @pubNubNode.sendInfoConnected
          
          @runStreamer = true
          @streamThread = Thread.new { streamer }
  
          @runReadingsPoster = true
          @readingsThread = Thread.new { readingsPoster }
  
          @suspendThread = nil

          @coolDownStamp = 0;
          
          @dataLock.synchronize {
            @enabled = true
          }
  
          if changed
            emitChanged
          end
        else
          $LOG.error("Device already enabled!")
        end
      }
    end
    
    # Emulates turning device off.
    # Disconnect from PubNub channel and stops streaming (if needed).
    def disable
      @mainLock.synchronize {
        if enabled?
          $LOG.info("Disabling device #{@devInfo.serialNb}.")
          @dataLock.synchronize {
            @enabled = false
          }
  
          @pubNubNode.disconnect(@devInfo.channel)
  
          @streamLock.synchronize {
            @streaming = false
            @runStreamer = false
            @streamCond.signal
          }
          @readingsLock.synchronize {
            @runReadingsPoster = false
            @readingsCond.signal
          }
          @streamThread.join
          @readingsThread.join
          
          if !@suspendThread.nil?
            resumeALS
            @suspendThread.join
          end
        end
      }
    end

    # Thread-safe check if device is enabled.
    def enabled?
      e = false
      @dataLock.synchronize {
        e = @enabled
      }
      e
    end

    # Gets copy of +DeviceAlarms+ object with alarms states.
    def currentAlarms
      alarms = nil
      @dataLock.synchronize {
        alarms = @alarms.clone
      }
      alarms
    end
    
    # Gets copy of +DeviceState+ object which represents current peripherals state.
    def currentState
      state = nil
      @dataLock.synchronize {
        state = @devState.clone
      }
      state
    end
    
    # Gets copy of +DeviceInfo+ object.
    def currentInfo
      info = nil
      @dataLock.synchronize {
        info = @devInfo.clone
      }
      info
    end
    
    # Emulates change of detected alarms.
    # If some alarm become active, then then backend is notified with apriopirate calls,
    # unless emulator is in cool down mode. 
    # Params:
    # +value+:: +DeviceAlarms+ object with new alarms states.
    def changeAlarms(value)
      @mainLock.synchronize {
        triggered = false
        @dataLock.synchronize {
          if value != @alarms
            $LOG.info("Changing alarms to #{value.to_s}.")

            old = @alarms
            @alarms = value.clone
            if @enabled
              triggered = triggerAlarm(old.co, @alarms.co, "co")
              triggered = (triggerAlarm(old.smoke, @alarms.smoke, "smoke") or triggered)
              triggered = (triggerAlarm(old.sound, @alarms.sound, "sound") or triggered)
              triggered = (triggerAlarm(old.battery, @alarms.battery, "low_battery") or triggered)
            end
          end
        }
        if triggered
          emitChanged
        end
      }
    end
    
    # Emulates change of temperature.
    # Params:
    # +value+:: New value for temperature (float).
    def changeTemperature(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devState.temperature 
            $LOG.info("Changing temperature to #{value}.")
            @devState.temperature = value
          end
        }
      }
    end
    
    # Emulates change of humidity.
    # +value+:: New value for humidity (float).
    def changeHumidity(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devState.humidity 
            $LOG.info("Changing humidity to #{value}.")
            @devState.humidity = value
          end
        }
      }
    end
    
    # Emulates user finishes adjusting the color via OFN.
    # +value+:: New value for color (HSV array).
    def changeColor(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devState.color 
            $LOG.info("Changing device color to #{value}.")
            @devState.color = value.clone
            if @enabled
              @pubNubNode.sendUserColor(@devInfo, @devState.color)
              @backendClient.putColor(@devInfo, @devState.color)
            end
          end
        }
      }
    end
    
    # Emulates serial number change.
    # +value+:: New value for SN.
    def changeSerialNb(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devInfo.serialNb
            $LOG.info("Changing device SN to #{value}.")
            @devInfo.serialNb = value.clone
            if @enaboled
              @backendClient.putDeviceInfo(@devInfo)
            end
          end
        }
      }
    end 
    
    # Emulates software version change.
    # +value+:: New value for SW version.
    def changeSwVersion(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devInfo.swVersion
            $LOG.info("Changing device SW version to #{value}.")
            @devInfo.swVersion = value.clone
            if @enaboled
              @backendClient.putDeviceInfo(@devInfo)
            end
          end
        }
      }
    end 
    
    # Sets ALS enabled internal state.
    # +value+:: New value for ALS enabled.
    def setALSEnabled(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devState._alsEnabled 
              $LOG.info("Setting ALS enabled to #{value}.")
              @devState._alsEnabled = value
          end
        }
      }
    end
    
    # Sets ALS suspended internal state.
    # +value+:: New value for ALS suspended.
    def setALSSuspended(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devState._alsSuspended 
              $LOG.info("Setting ALS suspended to #{value}.")
              @devState._alsSuspended = value
          end
        }
      }
    end
    
    # Sets test mode internal state.
    # +value+:: New value for test mode.
    def setTestMode(value)
      @mainLock.synchronize {
        @dataLock.synchronize {
          if value != @devState._testMode 
              $LOG.info("Setting test mode to #{value}.")
              @devState._testMode = value
          end
        }
      }
    end
    
    # Force emulator to ignore cool down mode (if entered).
    def resetCoolDownStamp()
      @mainLock.synchronize {
        @dataLock.synchronize {
          @coolDownStamp = 0
        }
      }
    end
    
    def start__streaming__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        @streamLock.synchronize {
          @streaming = true
          @streamCond.signal
        }
      }
    end
    
    def stop__streaming__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        @streamLock.synchronize {
          @streaming = false
        }
      }
    end
    
    def get__sensor__data__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        @dataLock.synchronize {
          if @enabled
            @pubNubNode.sendStreaming(@devInfo, @devState)
          end
        }
      }
    end
    
    def light__control__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        hsv = msg["hsv"]
        if !hsv.nil?
          changed = false
          @dataLock.synchronize {
            if @enabled
              old = @devState.color 
              @devState.color = [
                hsv["hue"],
                hsv["saturation"],
                hsv["value"]
              ]
              if old != @devState.color
                changed = true
                $LOG.info("Device color changed to #{@devState.color}.")
                @backendClient.putColor(@devInfo, @devState.color)
              end
            end 
          }
          if changed
            suspendALS
            emitChanged
          end
        end
      }
    end

    def get__user__color__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        @dataLock.synchronize {
          if @enabled
            @pubNubNode.sendUserColor(@devInfo, @devState.color)
          end
        }
      }
    end
    
    def als__enabled__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        changed = false
        @dataLock.synchronize {
          if @enabled  and !@devState._alsEnabled
            @devState._alsEnabled = true
            changed = true
            $LOG.info("ALS enabled.")
          end 
        }
        if changed
          emitChanged
        end
      }
    end

    def als__disabled__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        changed = false
        @dataLock.synchronize {
          if @enabled  and @devState._alsEnabled
            @devState._alsEnabled = false
            changed = true
            $LOG.info("ALS disabled.")
          end 
        }
        if changed
          emitChanged
        end
      }
    end

    def get__version__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        @dataLock.synchronize {
          if @enabled
            @pubNubNode.sendInfo(@devInfo)
          end
        }
      }
    end
    
    def get__connected__status__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        @dataLock.synchronize {
          if @enabled
            @pubNubNode.sendInfoConnected
          end
        }
      }
    end
    
    def fetch__update__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        # Emulate update by swVersion string change.
        @dataLock.synchronize {
          if @enabled
            @devInfo.swVersion += " (updated)"
          end
        }
        emitChanged
      }
    end

    def settings_update__handler(msg) 
      return unless enabled?
      @mainLock.synchronize {
        changed = false
  
        data = msg["data"]
        if !data.nil?
          serialNb = data["serial_number"]
          if !serialNb.nil?
            @dataLock.synchronize {
              if @enabled and serialNb != @devInfo.serialNb
                changed = true
                $LOG.info("Device SN changed to #{serialNb}.")
                @devInfo.serialNb = serialNb
              end
            }
          end
  
          swVersion = data["software_version"]
          if !swVersion.nil?
            @dataLock.synchronize {
              if @enabled  and swVersion != @devInfo.swVersion
                changed = true
                $LOG.info("Device SW version changed to #{swVersion}.")
                @devInfo.swVersion = swVersion
              end
            }
          end
        end
        
        if changed
          @backendClient.putDeviceInfo(@devInfo)
          emitChanged
        end
      }
    end
    
    def suspend__als__handler(msg) 
      return unless enabled?
      @mainLock.synchronize {
        suspendALS
      }
    end 

    def resume__als__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        resumeALS
      }
    end
    
    def dismiss__danger__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        if dismissAlarm(msg["sensor_type"])
          emitChanged
        end
      }
    end
    
    def issue__test__mode__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        changed = false
        @dataLock.synchronize {
          changed = !@devState._testMode 
          @devState._testMode = true
        }
        if changed
          emitChanged
        end
      }
    end
    
    def clear__danger__handler(msg)
      return unless enabled?
      @mainLock.synchronize {
        if dismissAlarm(msg["sensor_type"], false)
          emitChanged
        end
      }
    end

  private
    
    def emitChanged
      $LOG.info("Device changed.")
      for listener in @changeListenrs
        listener.call
      end
    end
    
    # Streamer thread code.
    def streamer
      lastTimestamp = Time.now
      @streamLock.synchronize {
        while @runStreamer
          if @streaming and Time.now - lastTimestamp > STREAMING_INTERVAL
            @dataLock.synchronize {
              if @enabled
                @pubNubNode.sendStreaming(@devInfo, @devState)
              end
            }
            lastTimestamp = Time.now
          end
    
          @streamCond.wait(@streamLock, @streaming ? 1 : nil)
        end
      }
    end

    # Readings poster thread code.
    def readingsPoster
      @readingsLock.synchronize {
        while @runReadingsPoster
          @dataLock.synchronize {
            if @enabled
              @backendClient.postReadings(@devInfo, @devState)
            end
          }
          @readingsCond.wait(@readingsLock, READINGS_INTERVAL)
        end
      }
    end
    
    def suspendALS
      @suspendLock.synchronize {
        @suspendStamp = Time.now.to_i

        @dataLock.synchronize {
          if @enabled and !@devState._alsSuspended
            @suspendThread = Thread.new {
              @suspendLock.synchronize {
                $LOG.info("ALS suspended.")
                change = false
                @dataLock.synchronize {
                  @devState._alsSuspended = true
                }
                emitChanged

                delta = SUSPEND_TIMEOUT
                while delta > 0
                  @suspendCond.wait(@suspendLock, delta + 0.1)
                  delta = SUSPEND_TIMEOUT - (Time.now.to_i - @suspendStamp)
                end

                @dataLock.synchronize {
                  @devState._alsSuspended = false
                }
                emitChanged
                $LOG.info("ALS resumed.")
              }
            }
          end
        }
      }
    end
    
    def resumeALS
      @suspendLock.synchronize {
        @suspendStamp = 0
        @suspendCond.signal
      }
    end
    
    def triggerAlarm(old, alarm, type)
      triggered = false
      if !old.active and alarm.active 
        if Time.now.to_i - @coolDownStamp > COOL_DOWN_TIMEOUT
          @backendClient.triggerAlarm(@devInfo, alarm, type)
          triggered = true
        else
          $LOG.info("Cool down mode - alarm ignored.")
        end
      end
      triggered
    end

    def deactiveteAlarm(alarm)
      changed = false
      if alarm.active
        alarm.active = false
        changed = true
      end
      changed
    end
    
    def dismissAlarm(type, coolDown = true)
      changed = false
      @dataLock.synchronize {
        if !type.nil?
          case type
          when "co"
            changed = deactiveteAlarm(@alarms.co)
          when "smoke"
            changed = deactiveteAlarm(@alarms.smoke)
          when "sound"
            changed = deactiveteAlarm(@alarms.sound)
          when "low_battery"
            changed = deactiveteAlarm(@alarms.battery)
          else
            $LOG.warn("Trying t dismiss unsupported alarm! Type: #{type}")
          end
        end
        if coolDown
          if changed
            @coolDownStamp = Time.now.to_i
            $LOG.info("\"#{type}\" alarm dismissed.")
          end
        else
          changed = (changed or @devState._testMode)
          @devState._testMode = false
        end
      }
      changed
    end
  end
end
