load "device_info.rb"
load "device_state.rb"
load "device_alarms.rb"
load "emu_logger.rb"
require "httpclient"
require "json"

module NightlightEmulator
  
  # BackendClient implements backend requests used by Leeo Nightlight.
  class BackendClient
    # Perform basic setup.
    # Params:
    # +backend+:: Backend API url.
    # +token+:: X-Api-Auth-Token.
    def initialize(backend, token)
      @backend = backend
      @token = token
      @httpClient = HTTPClient.new
      @simpleHeader = {"X-Api-Auth-Token" => @token}
      @jsonHeader = {"X-Api-Auth-Token" => @token, "Content-Type" => "application/json"}
      @wavHeader = {"Content-Type" => "audio/wav"}
    end
    
    # Gets device data from backend service
    # and updates its color and ALS state.
    # Params:
    # +info+:: +DeviceInfo+ object.
    # +state+:: +DeviceState+ object which will be updated with data from backend.
    # Returns true if devState has been changed, false otherwise.
    def getDeviceState(info, state)
      res = apiGet("devices/#{info.deviceId}")

      succeed = false
      
      if res.status == 200
        response = nil
        begin
          response = JSON.parse(res.body)
        rescue Exception => e  
          $LOG.warn("Invalid body received! Err: #{e.message}")
        end
        if !response.nil? and
           response.include?("als_enabled") and
           response.include?("color_hue") and
           response.include?("color_saturation") and
           response.include?("color_value")
          succeed = true
        end
      end
      changed = false
      if succeed
        alsEnabled = response["als_enabled"]
        color = [response["color_hue"].to_f, response["color_saturation"].to_f, response["color_value"].to_f] 
        if alsEnabled != state._alsEnabled or color != state.color 
          state._alsEnabled = alsEnabled
          state.color = color
          changed = true 
        end
      else
        $LOG.warn("Failed to get device state from backend! Status: #{res.status}, Response: #{res.body}")
      end
      changed
    end
    
    # Send device SW version and serial number to backend service.
    # Params:
    # +info+:: +DeviceInfo+ object.
    def putDeviceInfo(info)
      params = {
        :software_version => info.swVersion,
        :serial_number => info.serialNb
      }
      res = apiPut("devices/#{info.deviceId}", params)
      if res.status  != 200
        $LOG.warn("Failed to put device info to backend! Status: #{res.status}, Response: #{res.body}")
      end
    end

    # Send device color to backend service.
    # Params:
    # +info+:: +DeviceInfo+ object.
    # +color+:: HSV collor  array.
    def putColor(info, color)
      params = {
        :color_hue => color[0].to_s,
        :color_saturation => color[1].to_s,
        :color_value => color[2].to_s
      }
      res = apiPut("devices/#{info.deviceId}", params)
      if res.status  != 200
        $LOG.warn("Failed to put color to backend! Status: #{res.status}, Response: #{res.body}")
      end
    end

    # Send device readings (temp. and humid.) to backend service.
    # Params:
    # +info+:: +DeviceInfo+ object.
    # +state+:: +DeviceState+ object.
    def postReadings(info, state)
      params = {
        :device_id => info.deviceId,
        :sensor_data => [
          {
            :type => "Temperature",
            :value => state.temperature,
            :time => Time.now.to_i
          },
          {
            :type => "Humidity",
            :value => state.humidity,
            :time => Time.now.to_i
          }
        ]
      }
      res = apiPostJson("readings", params)
      if res.status  != 201
        $LOG.warn("Failed to post readings to backend! Status: #{res.status}, Response: #{res.body}")
      end
    end
    
    # Triggers new alarm - upload sound file to S3 (if given), update storage url
    # and post new alarm. Finally +alarm+ is updated with posted alarm Id.
    # Params:
    # +info+:: +DeviceInfo+ object.
    # +alarm+:: +DeviceAlarms::State+ object.
    # +type+:: Given alarm type.
    def triggerAlarm(info, alarm, type)
      uploadSoundFile(info, alarm, type)
      
      params = {
        :device_id => info.deviceId,
        :alarm_type => type,
        :storage_url => alarm.storageUrl
      }
      res = apiPost("alarms", params)
      if res.status  == 201
        begin
          response = JSON.parse(res.body)
          alarm._id = response["id"]
          $LOG.info("Triggered \"#{type}\" alarm. Id: #{alarm._id}")
        rescue Exception => e  
          $LOG.warn("Invalid body received on trigger alarm! Err: #{e.message}")
        end
      else
        $LOG.warn("Failed to post \"#{type}\" alarm to backend! Status: #{res.status}, Response: #{res.body}")
      end
    end
 
    def apiGet(path, params = nil)
      @httpClient.default_header =  @simpleHeader
      res = @httpClient.get("#{@backend}/#{path}",
        :query => params
      )
      res
    end
    
    def apiPost(path, params = nil)
      @httpClient.default_header =  @simpleHeader
      res = @httpClient.post("#{@backend}/#{path}",
        :body => params
      )
      res
    end
    
    def apiPostJson(path, params = nil)
      @httpClient.default_header =  @jsonHeader
      res = @httpClient.post("#{@backend}/#{path}",
        :body => JSON.generate(params)
      )
      res
    end

    def apiPut(path, params = nil)
      @httpClient.default_header =  @simpleHeader
      res = @httpClient.put("#{@backend}/#{path}",
        :body => params
      )
      res
    end

    def apiDel(path)
      @httpClient.default_header =  @simpleHeader
      res = @httpClient.delete("#{@backend}/#{path}"
      )
      res
    end
    
  private
    # Tries to upload associated sound, if given, and update storageUrl.
    def uploadSoundFile(info, alarm, type)
      if !alarm.sound.nil?
        # reset storageUrl
        alarm.storageUrl = nil

        # get new urls
        params = {
          :device_id => info.deviceId,
          :alarm_type => type
        }
        res = apiPost("storage/alarm", params)
        
        if res.status  == 201
          uploadUrl = downloadUrl = nil
          begin
            response = JSON.parse(res.body)
            downloadUrl = response["read_url"]
            uploadUrl = response["signed_url"]
          rescue Exception => e  
            $LOG.warn("Invalid body received on post storage/alarm! Err: #{e.message}")
          end
          
          if !uploadUrl.nil? and !downloadUrl.nil?
            # upload WAV 
            @httpClient.default_header =  @wavHeader
            begin
              File.open(alarm.sound) { |file|
                res = @httpClient.put(uploadUrl,
                  :body => file
                )
                if res.status  == 200
                  # set storageUrl if everything succeed
                  alarm.storageUrl = downloadUrl
                else
                  $LOG.warn("Failed to put alarm sound to S3! Body: #{res.body}")
                end
              }
            rescue Exception => e  
              $LOG.warn("Failed to open sound file! Err: #{e.message}")
            end
          else
            $LOG.warn("Failed to get S3 upload/download urls!")
          end
        else
          $LOG.warn("Failed to post \"#{type}\" alarm to get S3 urls from backend! Status: #{res.status}, Response: #{res.body}")
        end
      end
    end
  end
end
