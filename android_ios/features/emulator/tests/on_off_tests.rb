require "device"
require "test/unit"

class OnOffTests < Test::Unit::TestCase
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
  
  def test_connected
    waitStatus = true
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
    
    @@device.enable

    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }

    assert_equal(false, response["connected"].nil?)
    assert_equal("yes", response["connected"])
    
    request = {:type => "get-connected-status"}
    @@pubNub.publish(:message => JSON.generate(request), :channel => CHANNEL, :http_sync => true)
    
    @@waitLock.synchronize {
      if waitStatus
        @@waitCond.wait(@@waitLock, MAX_TIMEOUT)
      end
      assert_equal(false, waitStatus)
    }
    @@pubNub.unsubscribe(:channel => CHANNEL, :http_sync => true)

    assert_equal(false, response["connected"].nil?)
    assert_equal("yes", response["connected"])
    @@device.disable
  end

  def test_startup
    info = @@device.currentInfo 
    oldColor = [0.3, 0.4, 0.5]
    @@device.changeColor(oldColor)
    @@device.setALSEnabled(false)
    params = {
      :software_version => "obsoleteSwVersion",
      :serial_number => "obsoleteSerialNumber"
    }
    res = @@backendClient.apiPut("devices/#{info.deviceId}", params)
    assert_equal(200, res.status)
    newColor = [0.5, 0.4, 0.3]
    params = {
      :color_hue => newColor[0].to_s,
      :color_saturation => newColor[1].to_s,
      :color_value => newColor[2].to_s,
      :als_enabled => true
    }
    res = @@backendClient.apiPut("devices/#{info.deviceId}", params)
    assert_equal(200, res.status)
  
    @@device.enable
    
    state = @@device.currentState
    assert_equal(newColor, state.color)
    assert_equal(true, state._alsEnabled)
    
    res = @@backendClient.apiGet("devices/#{info.deviceId}")
    assert_equal(200, res.status)
    response = nil
    begin
      response = JSON.parse(res.body)
    rescue Exception => ex
      puts ex.message  
    end
    assert_equal(false, response.nil?)
    assert_equal(info.swVersion, response["software_version"])
    assert_equal(info.serialNb, response["serial_number"])
    @@device.disable
  end
end
