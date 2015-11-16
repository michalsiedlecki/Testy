require "backend_client"
require "test/unit"

class BackendClientTests < Test::Unit::TestCase
  BACKEND = "http://test.leeo.com/api"
  TOKEN = "a090e2bd-9433-4119-87de-caac1776b198"
  
  @@backendClient = NightlightEmulator::BackendClient.new(BACKEND,TOKEN) 

  def test_commonApi
    params = {:name => "locationTestName"}
    res = @@backendClient.apiPost("locations", params)
    assert_equal(201, res.status)
    response = nil
    begin
      response = JSON.parse(res.body)
    rescue Exception => ex
      puts ex.message  
    end
    assert_equal(false, response.nil?)
    assert_equal("locationTestName", response["name"])
    locationId = response["id"]

    params = {
      :user_id => 24,
      :page => 1,
      :per_page => 20
    }
    res = @@backendClient.apiGet("locations", params)
    assert_equal(200, res.status)
    response = nil
    begin
      response = JSON.parse(res.body)
    rescue Exception => ex
      puts ex.message  
    end
    assert_equal(false, response.nil?)
    assert(1 <= response.size)
    i = 0
    while i < response.size
      if response[i]["id"] == locationId
        break
      end
      i += 1
    end
    assert_equal(false, response.nil?)
    assert(i < response.size)
    location = response[i]
    assert_equal(locationId, location["id"])

    params = {
      :temperature_unit => "c",
      :name => "newLocationTestName"
    } 
    res = @@backendClient.apiPut("locations/#{locationId}", params)
    assert_equal(200, res.status)
    response = nil
    begin
      response = JSON.parse(res.body)
    rescue Exception => ex
      puts ex.message  
    end
    assert_equal(false, response.nil?)
    assert_equal(locationId, response["id"])
    assert_equal("c", response["temperature_unit"])
    assert_equal("newLocationTestName", response["name"])

    res = @@backendClient.apiDel("locations/#{locationId}")
    assert_equal(200, res.status)
    response = nil
    begin
      response = JSON.parse(res.body)
    rescue Exception => ex
      puts ex.message  
    end
    assert_equal(false, response.nil?)
    assert_equal(locationId, response["id"])
    assert_equal(true, response["destroyed"])

    params = {
      :device_id => 82,
      :sensor_data => [
        {
          :type => "Temperature",
          :value => 23.5,
          :time => Time.now.to_i
        },
        {
          :type => "Humidity",
          :value => 55.5,
          :time => Time.now.to_i
        }
      ]
    }
    res = @@backendClient.apiPostJson("readings", params)
    assert_equal(201, res.status)
  end
end
