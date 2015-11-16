#!/usr/bin/env ruby

Dir.chdir(File.expand_path(File.dirname(__FILE__)))
Dir.chdir("../")
load "device.rb"
require "json"
require "listen"

$devices = Hash.new


def updateConfig(dev, fName)
  begin
    json = File.read(fName)
    config = JSON.parse(json)

    info = dev.currentInfo
    config["info"] = {
      :serialNb => info.serialNb,
      :swVersion => info.swVersion,
      :deviceId => info.deviceId,
      :channel => info.channel,
      :token => info.token,
    }
    
    state = dev.currentState
    config["state"] = {
      :temperature => state.temperature,
      :humidity => state.humidity,
      :color => state.color,
      :_alsEnabled => state._alsEnabled,
      :_alsSuspended => state._alsSuspended,
      :_testMode => state._testMode
    }

    alarms = dev.currentAlarms
    config["alarms"] = {
      :co => {
        :active => alarms.co.active,
        :sound => alarms.co.sound,
        :storageUrl => alarms.co.storageUrl,
        :_id => alarms.co._id
      },
      :smoke => {
        :active => alarms.smoke.active,
        :sound => alarms.smoke.sound,
        :storageUrl => alarms.smoke.storageUrl,
        :_id => alarms.smoke._id
      },
      :sound => {
        :active => alarms.sound.active,
        :sound => alarms.sound.sound,
        :storageUrl => alarms.sound.storageUrl,
        :_id => alarms.sound._id
      },
      :battery => {
        :active => alarms.battery.active,
        :sound => alarms.battery.sound,
        :storageUrl => alarms.battery.storageUrl,
        :_id => alarms.battery._id
      }
    }
    
    config["enabled"] = dev.enabled?

    json = JSON.pretty_generate(config)
    
    File.open(fName,  "w") { |file|
      file.write(json)
    }
  rescue Exception => e  
    puts "Failed to update config: #{e.message}"  
  end
end

def readAlarmConfig(config)
  alarm = nil
  if !config.nil?
    alarm = NightlightEmulator::DeviceAlarms::State.new(
      config["active"],
      config["sound"],
      config["storageUrl"],
      config["_id"]
    )
  end
  alarm
end

def createDev(config, fName, key)
  connection = info = state = alarms = nil
    
  subConfig = config["connection"]
  if !subConfig.nil?
    connection = NightlightEmulator::ConnectionSetup.new(
    subConfig["origin"],
    subConfig["publishKey"],
    subConfig["subscribeKey"],
    subConfig["backend"]
    )
  else
    raise "Incomplete device file! Missing 'connection'."
  end

  subConfig = config["info"]
  if !subConfig.nil?
    info = NightlightEmulator::DeviceInfo.new(
    subConfig["serialNb"],
    subConfig["swVersion"],
    subConfig["deviceId"],
    subConfig["channel"],
    subConfig["token"]
    )
  else
    raise "Incomplete device file! Missing 'info'."
  end
    
  subConfig = config["state"]
  if !subConfig.nil?
    state = NightlightEmulator::DeviceState.new(
    subConfig["temperature"],
    subConfig["humidity"],
    subConfig["color"],
    subConfig["_alsEnabled"],
    subConfig["_alsSuspended"],
    subConfig["_testMode"]
    )
  else
    state = NightlightEmulator::DeviceState.new
  end

  subConfig = config["alarms"]
  if !subConfig.nil?
    alarms = NightlightEmulator::DeviceAlarms.new(
      readAlarmConfig(subConfig["co"]),
      readAlarmConfig(subConfig["smoke"]),
      readAlarmConfig(subConfig["sound"]),
      readAlarmConfig(subConfig["battery"])
    )
  else
    alarms = NightlightEmulator::DeviceAlarms.new
  end

  dev = NightlightEmulator::Device.new(connection,  info,  state, alarms)
  
  $devices[key] = dev
  dev.addListener(lambda {
    updateConfig(dev, fName)
  })

  if config["enabled"]
    dev.enable
  end
  dev
end

def addDevice(fName)
  key = Pathname.new(fName).basename
  if !$devices.include?(key)
    puts "Adding device #{key} ..."
    begin
      json = File.read(fName)
      config = JSON.parse(json)

      createDev(config, fName, key)
    rescue Exception => e  
      puts "Failed to add device: #{e.message}"  
    end
  else
    updateDevice(fName)
  end
end

def updateDevice(fName)
  key = Pathname.new(fName).basename
  if $devices.include?(key)
    puts "Updating device #{key} ..."
    dev = $devices[key]
    
    begin
      json = File.read(fName)
      config = JSON.parse(json)
  
      subConfig = config["info"]
      if !subConfig.nil?
        dev.changeSwVersion(subConfig["swVersion"])
        dev.changeSerialNb(subConfig["serialNb"])
      end

      subConfig = config["state"]
      if !subConfig.nil?
        dev.changeTemperature(subConfig["temperature"])
        dev.changeHumidity(subConfig["humidity"])
        dev.changeColor(subConfig["color"])
        dev.setALSEnabled(subConfig["_alsEnabled"])
        dev.setALSSuspended(subConfig["_alsSuspended"])
        dev.setTestMode(subConfig["_testMode"])
      end

      subConfig = config["alarms"]
      if !subConfig.nil?
        alarms = NightlightEmulator::DeviceAlarms.new(
          readAlarmConfig(subConfig["co"]),
          readAlarmConfig(subConfig["smoke"]),
          readAlarmConfig(subConfig["sound"]),
          readAlarmConfig(subConfig["battery"])
        )
        dev.changeAlarms(alarms)
      end

      if config["enabled"]
        if !dev.enabled?
          # recreate device to takie connection changes into account
          createDev(config, fName, key)
        end
      else
        dev.disable
      end
    rescue Exception => e  
      puts "Failed to update device: #{e.message}"  
    end
  else
    addDevice(fName)
  end
end

def removeDevice(fName)
  key = Pathname.new(fName).basename
  if $devices.include?(key)
    puts "Removing device #{key} ..."
    dev = $devices[key]
    dev.disable
    $devices.delete(key)
  end
end

# Add existing files.
Dir.glob('./emulator/devices/*.json') do |fName|
  addDevice(fName)
end

# Start watching.
listener = Listen.to("./emulator/devices/", only: /\.json$/) do |modified, added, removed|
  begin
    for fName in added
      addDevice(fName)
    end
    for fName in modified
      updateDevice(fName)
    end
    for fName in removed
      removeDevice(fName)
    end
  rescue Exception => e  
    puts e.message  
  end
end

begin
  listener.start
rescue Exception => e  
  puts "Failed to start listening #{e.message}"  
end

puts "Press ctrl+c to stop emulator."

running = true
Signal.trap("TERM") {
  running = false
}

Signal.trap("INT") {
  running = false
}

sleep(1) while running

listener.stop

for dev in $devices.values
  dev.disable
end
