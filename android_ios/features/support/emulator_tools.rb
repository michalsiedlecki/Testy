require 'json'
require 'fileutils'
require 'daemons'
#fName = 'test_device1.json'
#file name format

#we should run emulator before using that script 
#or we can run them by adding: 
#load "emulator.rb"
def emulator(option)
  emulator_file = $DEV_DIR + 'emulator_control.rb'
  if option=="start"
    success = system("ruby #{emulator_file} start")
    if success
      $LOGGER.info("Emulator is running")
    else
      fail ("Emulator was not started")
    end
  end
  if option=="status"
     output=`ruby #{emulator_file} status`
     return output
  end
  if option=="stop"
    success = system("ruby #{emulator_file} stop")
    if success
      $LOGGER.info("Emulator was stopped")
    else
      puts "Emulator was not stopped"
      system("ruby #{emulator_file} status")
    end
  end
end

def createConfigFile(config=nil, fName)
  #create config file for new device 
  #if config = nil example file will be used
  config_path=$DEV_DIR + 'devices/'
  if !fName.nil?
    FileUtils.cp(config_path + 'example.json', config_path + fName)
    if !config.nil?
      updateConfigFile(config, fName)
    end
  else
    puts "Failed to create config with empty filename"  
  end
end

def updateConfigFile(config, fName)
  #update device file with new config
  fName = $DEV_DIR + 'devices/' + fName
  json = File.read(fName)
  config_old = JSON.parse(json)
  for i in config_old.keys
    if !config[i].nil? && !config[i].is_a?(TrueClass) && !config[i].is_a?(FalseClass)
      for y in config_old[i].keys
        if !config[i][y].nil?
          config_old[i][y] = config[i][y]
        end
      end
    elsif config[i].is_a?(TrueClass) || config[i].is_a?(FalseClass)
      config_old[i]=config[i]
    end     
  end
  json = JSON.pretty_generate(config_old)
  begin    
    File.open(fName,  "w") { |file|
      file.write(json)
      }
  rescue Exception => e  
    puts "Failed to update config: #{e.message}"  
  end
end

def readConfigFile(fName)
  #read device file to hash
  fName = $DEV_DIR + 'devices/' + fName
  json = File.read(fName)
  config = JSON.parse(json)
  return config
end


def deleteConfigFile(fName)
  #delete device file
  if !fName.include?("example")
    fName = $DEV_DIR  + 'devices/' + fName
    begin
      File.delete(fName)
    rescue SystemCallError => e
      $stderr.puts e.message
    end
  else
    puts "Cannot remove example file"
  end
end
      
      
      
#example config   
config = {}
config["enabled"] = true 
config["connection"] =  {
    "origin" => "pubsub.pubnub.com",
    "publishKey" =>"pub-c-b8f0aa53-b914-4af4-ab62-2f35d53b6aea",
    "subscribeKey" => "sub-c-d28e2f60-4c64-11e4-9e3d-02ee2ddab7fe",
    "backend" => "http://qa.leeo.com/api"
    }

config["info"] = {
      "serialNb" => "wbted",
      "swVersion" => "1.0-17",
      "deviceId" => "1584",
      "channel" => "dhrrmibzaiuhhpquqcqsqlflk",
      "token" => "ba9b96cc-e4b9-4be9-8eb5-dd03d4ff9389",
    }

config["state"] = {
      "temperature" => 20,
      "humidity" => 40,
      "color" => [0, 1, 1],
      "_alsEnabled" => false,
      "_alsSuspended" => false,
      "_testMode" => false,
    }
config["alarms"] = {
      "co" => {
        "active" => false,
        "sound" => nil,
        "storageUrl" => nil,
        "_id" => nil
      },
      "smoke" => {
        "active" => false,
        "sound" => nil,
        "storageUrl" => nil,
        "_id" => nil
      },
      "sound" => {
        "active" => false,
        "sound" => nil,
        "storageUrl" => nil,
        "_id" => nil
      },
      "battery" => {
        "active" => false,
        "sound" => nil,
        "storageUrl" => nil,
        "_id" => nil
      }
    }

# usage examples
# createConfigFile(fName)
# readConfigFile(fName)
# updateConfigFile(config,fName)
# deleteConfigFile(fName)

