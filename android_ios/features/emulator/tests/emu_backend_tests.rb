require "device"
require "test/unit"

class EmuBackendTests < Test::Unit::TestCase
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
  @@backendClient = NightlightEmulator::BackendClient.new(@@connection.backend, TOKEN)
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

  def test_color
    oldColor = [0.3, 0.4, 0.5]
    @@device.changeColor(oldColor)
    devInfo = @@device.currentInfo
    devState = @@device.currentState
    newColor = [0.5, 0.4, 0.3]

    @@device.changeColor(newColor)
    assert_equal(true, @@backendClient.getDeviceState(devInfo, devState))
    assert_equal(false, @@backendClient.getDeviceState(devInfo, devState))
    assert_equal(newColor, devState.color)

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
        :hue => oldColor[0],
        :saturation => oldColor[1],
        :value => oldColor[2]
      }
    }
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    devState = @@device.currentState
    assert_equal(oldColor, devState.color)
    @@backendClient.getDeviceState(devInfo, devState)
    assert_equal(oldColor, devState.color)

    @@device.removeListener(listener)
  end

  def test_triggerAlarmsWithoutSound
    @@device.resetCoolDownStamp()
    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)

    alarms = NightlightEmulator::DeviceAlarms.new
    @@device.changeAlarms(alarms)
    alarms.co.active = alarms.smoke.active = alarms.battery.active = true
    @@device.changeAlarms(alarms)
    alarms = @@device.currentAlarms
    assert_equal(true, alarms.co.active)
    assert_equal(false, alarms.co._id.nil?)
    assert_equal(true, alarms.smoke.active)
    assert_equal(false, alarms.smoke._id.nil?)
    assert_equal(true, alarms.battery.active)
    assert_equal(false, alarms.battery._id.nil?)

    # check alarms with backend info
    checkAlarmDetails = lambda { |alarm, type|
      res = @@backendClient.apiGet("alarms/#{alarm._id}")
      assert_equal(200, res.status)
      response = nil
      begin
        response = JSON.parse(res.body)
      rescue Exception => ex
        puts ex.message
      end
      assert_equal(alarm._id, response["id"])
      assert_equal(alarm.storageUrl, response["storage_url"])
      assert_equal(type, response["sensor_type"])
    }
    checkAlarmDetails.call(alarms.co, "co")
    checkAlarmDetails.call(alarms.smoke, "smoke")
    checkAlarmDetails.call(alarms.battery, "low_battery")

    # dismiss alarms via backend
    dismissAlarm = lambda { |alarm|
      waitStatus = true
      res = @@backendClient.apiPost("alarms/#{alarm._id}/dismiss")
      assert_equal(201, res.status)
      @@waitLock.synchronize {
        if waitStatus
          @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
        end
        assert_equal(false, waitStatus)
      }
    }
    dismissAlarm.call(alarms.co)
    alarms = @@device.currentAlarms
    assert_equal(false, alarms.co.active)
    dismissAlarm.call(alarms.smoke)
    alarms = @@device.currentAlarms
    assert_equal(false, alarms.smoke.active)
    dismissAlarm.call(alarms.battery)
    alarms = @@device.currentAlarms
    assert_equal(false, alarms.battery.active)

    @@device.removeListener(listener)

    # trigger some alarm wo sound again
    alarms.co.active = true
    alarms.co._id = nil
    @@device.changeAlarms(alarms)
    alarms = @@device.currentAlarms
    assert_equal(true, alarms.co._id.nil?)
  end

  def test_triggerAlarmWithSound
    @@device.resetCoolDownStamp()
    # trigger smoke alarm with sound
    alarms = NightlightEmulator::DeviceAlarms.new
    @@device.changeAlarms(alarms)
    alarms.smoke().active = true
    alarms.smoke().sound = "emulator/devices/ALARM.WAV"
    @@device.changeAlarms(alarms)
    alarms = @@device.currentAlarms
    assert_equal(true, alarms.smoke.active)
    assert_equal("emulator/devices/ALARM.WAV", alarms.smoke.sound)
    assert_equal(false, alarms.smoke.storageUrl.nil?)
    assert_equal(false, alarms.smoke._id.nil?)

    # check alarms with backend info
    res = @@backendClient.apiGet("alarms/#{alarms.smoke._id}")
    assert_equal(200, res.status)
    response = nil
    begin
      response = JSON.parse(res.body)
    rescue Exception => ex
      puts ex.message
    end
    assert_equal(alarms.smoke._id, response["id"])
    assert_equal(alarms.smoke.storageUrl, response["storage_url"])
    assert_equal("smoke", response["sensor_type"])

    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)

    # dismiss danger via backend
    res = @@backendClient.apiPost("alarms/#{alarms.smoke._id}/dismiss")
    assert_equal(201, res.status)

    # download wav and check content
    sameFiles = (File.binread("emulator/devices/ALARM.WAV") == HTTPClient.new.get_content(alarms.smoke.storageUrl))
    assert_equal(true, sameFiles)
    
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    @@device.removeListener(listener)
  end

  def test_testMode
    @@device.resetCoolDownStamp()
    @@device.setTestMode(false)
    waitStatus = true
    listener = lambda{
      @@waitLock.synchronize {
        waitStatus = false
        @@waitCond.signal
      }
    }
    @@device.addListener(listener)
    # issue test mode
    request = { :type => "issue-test-mode"}
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    assert_equal(true, @@device.currentState._testMode)

    # trigger some alarm
    alarms = NightlightEmulator::DeviceAlarms.new
    @@device.changeAlarms(alarms)
    alarms.battery.active = true
    @@device.changeAlarms(alarms)
    alarms = @@device.currentAlarms
    assert_equal(true, alarms.battery.active)
    assert_equal(false, alarms.battery._id.nil?)

    # clear danger
    waitStatus = true
    request = {
      :type => "clear-danger",
      :sensor_type => "low_battery"
    }
    @@pubNub.publish(:message => request, :channel => CHANNEL, :http_sync => true)
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    alarms = @@device.currentAlarms
    assert_equal(false, alarms.battery.active)
    assert_equal(false, @@device.currentState._testMode)

    # dismiss danger via backend
    waitStatus = true
    res = @@backendClient.apiPost("alarms/#{alarms.battery._id}/dismiss")
    assert_equal(201, res.status)

    # trigger some alarm again
    alarms = @@device.currentAlarms
    alarms.smoke.active = true
    @@device.changeAlarms(alarms)
    alarms = @@device.currentAlarms
    assert_equal(true, alarms.smoke.active)
    assert_equal(false, alarms.smoke._id.nil?)

    # dismiss danger via backend
    waitStatus = true
    res = @@backendClient.apiPost("alarms/#{alarms.smoke._id}/dismiss")
    assert_equal(201, res.status)
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    @@device.removeListener(listener)
  end
end
