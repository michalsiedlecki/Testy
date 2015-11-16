require "device"
require "test/unit"

class EmuAppTests < Test::Unit::TestCase
  ORIGIN = "pubsub.pubnub.com"
  SUBSCRIBE_KEY = "sub-c-d28e2f60-4c64-11e4-9e3d-02ee2ddab7fe"
  PUBLISH_KEY = "pub-c-b8f0aa53-b914-4af4-ab62-2f35d53b6aea"
  BACKEND = "http://test.leeo.com/api"
  TOKEN = "a090e2bd-9433-4119-87de-caac1776b198"
  CHANNEL = "testDeviceChannel"
  MAX_TIMEOUT = 30

  @@connection = NightlightEmulator::ConnectionSetup.new(ORIGIN, PUBLISH_KEY, SUBSCRIBE_KEY, BACKEND)
  @@device = NightlightEmulator::Device.new(@@connection,
               NightlightEmulator::DeviceInfo.new("testSerialNumber", "testVersionString", 82, CHANNEL, TOKEN),
               NightlightEmulator::DeviceState.new
             )
  @@pubNub = Pubnub.new(
    :publish_key => PUBLISH_KEY,
    :subscribe_key  => SUBSCRIBE_KEY,
    :origin => ORIGIN,
    :error_callback => lambda{ |e|
      puts "ERROR! #{e.inspect}"
    }
  )

  @@waitLock = Mutex.new
  @@waitCond = ConditionVariable.new
  
  class << self
    def startup
      @@device.enable
    end
    def shutdown
      @@device.disable
    end
  end
  
  def test_version
    waitStatus = true
    devInfo = @@device.currentInfo
    response = nil
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => true)
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => false){ |e|
      if !e.message.nil? and e.message["type"] == "info"
        response = e.message
        @@waitLock.synchronize {
          waitStatus = false
          @@waitCond.signal
        }
      end
    }
    
    request = {:type => "get-version"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    @@pubNub.unsubscribe(:channel => CHANNEL, :http_sync => true)
    
    assert_equal(false, response["version"].nil?)
    assert_equal(devInfo.swVersion, response["version"])
  end

  def test_sensorData
    waitStatus = true
    devInfo = @@device.currentInfo
    devState = @@device.currentState 
    response = nil
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => true)
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => false){ |e|
      if !e.message.nil? and e.message["type"] == "streaming"
        response = e.message
        @@waitLock.synchronize {
          waitStatus = false
          @@waitCond.signal
        } 
      end
    }
    
    request = {:type => "get-sensor-data"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    @@pubNub.unsubscribe(:channel => CHANNEL, :http_sync => true)

    assert_equal(false, response["sensor_data"].nil?)
    assert_equal(2, response["sensor_data"].size)
    tempFound = false
    humFound = false
    for v in response["sensor_data"]
      case v["type"]
      when "Temperature"
        assert_equal(false, v["value"].nil?)
        assert_equal(devState.temperature, v["value"])
        tempFound = true
      when "Humidity"
        assert_equal(false, v["value"].nil?)
        assert_equal(devState.humidity, v["value"])
        humFound = true
      end
    end
    assert_equal(true, tempFound)
    assert_equal(true, humFound)
    assert_equal(devInfo.swVersion, response["version"])
  end

  def test_color
    oldColor = [0.3, 0.4, 0.5]
    @@device.changeColor(oldColor)
    devInfo = @@device.currentInfo
    newColor = [0.5, 0.4, 0.3]
    waitStatus = true
    response = nil
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => true)
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => false){ |e|
      if !e.message.nil? and e.message["type"] == "user-color"
        response = e.message
        @@waitLock.synchronize {
          waitStatus = false
          @@waitCond.signal
        }
      end
    }

    @@device.changeColor(oldColor)
    @@device.changeColor(newColor)
  
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    assert_equal(false, response["device_id"].nil?)
    assert_equal(devInfo.deviceId, response["device_id"])
    color = response["user_color"]
    assert_equal(false, color.nil?)
    assert_equal(newColor[0], color["hue"])
    assert_equal(newColor[1], color["saturation"])
    assert_equal(newColor[2], color["value"])

    request = {:type => "get-user-color"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
      
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    @@pubNub.unsubscribe(:channel => CHANNEL, :http_sync => true)
    
    assert_equal(false, response["device_id"].nil?)
    assert_equal(devInfo.deviceId, response["device_id"])
    color = response["user_color"]
    assert_equal(false, color.nil?)
    assert_equal(newColor[0], color["hue"])
    assert_equal(newColor[1], color["saturation"])
    assert_equal(newColor[2], color["value"])
  end
  
  def test_alsHandler
    @@device.setALSEnabled(true)
    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)

    request = {:type => "als-disabled"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    state = @@device.currentState
    assert_equal(false, state._alsEnabled)

    waitStatus = true

    request = {:type => "als-enabled"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    state = @@device.currentState
    assert_equal(true, state._alsEnabled)

    @@device.removeListener(listener)
  end

  def test_colorHandler
    newColor = [0.9, 0.8, 0.7]
    @@device.changeColor([0.1, 0.2, 0.3])
    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)
  
    request = {
      :type => "light-control",
      :hsv => {
        :hue => newColor[0],
        :saturation => newColor[1],
        :value => newColor[2]
      }
    }
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
  
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    state = @@device.currentState
    assert_equal(newColor, state.color)

    @@device.removeListener(listener)
  end
  
  def test_streaming
    waitStatus = true
    devInfo = @@device.currentInfo
    devState = @@device.currentState
    response = nil
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => true)
    @@pubNub.subscribe(:channel => CHANNEL, :http_sync => false){ |e|
      if !e.message.nil? and e.message["type"] == "streaming"
        response = e.message
        @@waitLock.synchronize {
          waitStatus = false
          @@waitCond.signal
        } 
      end
    }
    
    request = {:type => "start-streaming"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT * 2)
      end
      assert_equal(false, waitStatus)
    }
    
    request = {:type => "stop-streaming"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
    @@pubNub.unsubscribe(:channel => CHANNEL, :http_sync => true)

    assert_equal(false, response["sensor_data"].nil?)
    assert_equal(2, response["sensor_data"].size)
    tempFound = false
    humFound = false
    for v in response["sensor_data"]
      case v["type"]
      when "Temperature"
        assert_equal(false, v["value"].nil?)
        assert_equal(devState.temperature, v["value"])
        tempFound = true
      when "Humidity"
        assert_equal(false, v["value"].nil?)
        assert_equal(devState.humidity, v["value"])
        humFound = true
      end
    end
    assert_equal(true, tempFound)
    assert_equal(true, humFound)
    assert_equal(devInfo.swVersion, response["version"])
  end

  def test_suspendALSHandler
    @@device.setALSEnabled(true)
    @@device.setALSSuspended(false)
    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)

    request = {:type => "suspend-als"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    state = @@device.currentState
    assert_equal(true, state._alsSuspended)

    waitStatus = true

    request = {:type => "resume-als"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    state = @@device.currentState
    assert_equal(false, state._alsSuspended)

    @@device.removeListener(listener)
  end

  def test_updateHandler
    devInfo = @@device.currentInfo
    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)
  
    request = {:type => "fetch-update"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
  
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    info = @@device.currentInfo
    assert_equal(devInfo.swVersion + " (updated)", info.swVersion)

    @@device.removeListener(listener)
  end

  def test_settingsUpdateHandler
    waitStatus = true
    expectedSN = "newDevSerialNumber"
    expectedVersion = "newDevSWVersion"
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)
  
    request = {
      :type => "settings_update",
      :device_id => @@device.currentInfo.deviceId,
      :data =>  {
        :serial_number => expectedSN,
        :software_version => expectedVersion
      }
    }
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
  
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    info = @@device.currentInfo
    assert_equal(expectedSN, info.serialNb)
    assert_equal(expectedVersion, info.swVersion)

    @@device.removeListener(listener)
  end
end
