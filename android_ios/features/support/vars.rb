
$LOGGER = Logger.new(STDOUT)
$LOGGER.formatter = proc do |severity, datetime, progname, msg|
  if severity == "INFO"
    "\e[1;32m #{severity}: #{msg}\n"
    elsif severity == "WARN"
    "\e[1;33m #{severity}: #{msg}\n"
    elsif severity == "ERROR"
    "\e[1;31m #{severity}: #{msg}\n"  
  end
end

$TIMEOUT = {:timeout => 30, :post_timeout => 0.8}

#PubNub keys 
$ORIGIN = "pubsub.pubnub.com"
$SUB_KEY = "sub-c-d28e2f60-4c64-11e4-9e3d-02ee2ddab7fe"
$PUB_KEY = "pub-c-b8f0aa53-b914-4af4-ab62-2f35d53b6aea"
#HW Emulator data devices folder
$EMULATOR=true
if  $EMULATOR
  $DEV_DIR = 'features/emulator/nightlight-emulator/emulator/'
  $LOGGER.info("Hardware Emulator usage enabled")
end

#user config
# $EMAIL = "leeo.blstest+2@gmail.com"
# $PASSWORD = "asdfasdf"
$EMAIL = nil
$PASSWORD = nil
$NAME = "Leeo BLS Test"
$PHONE_NUMBER = "+14123456782"

#Gmail account data
$GMAIL_PASSWORD="blstest!123"

#residevce config template
$LOC_DATA =
    {
        "temperature_unit"=> "f",
        "smoke_detector_count"=> 0,
        "co_detector_count"=> 0,
        "dual_detector_count"=> 0,
        "checked_detectors_at"=> nil,
        "alarm_test_reminders_remaining"=> nil,
        "last_alarm_test_reminder_at"=> nil,
        "address_line_1"=> "989 Commercial St",
        "address_line_2"=> nil,
        "address_city"=> "Palo Alto",
        "address_state"=> "CA",
        "address_zip"=> "94303",
        "address_country"=> "US",
        "emergency_number"=> "911",
      }

#device config template
$DEVICE_DATA = 
      {    
            "software_version"=> "1.0-21",
            "pir_enabled"=> false,
            "als_enabled"=> false,
            "color_hue"=> "0.7875685691833496",
            "color_value"=> "1.0",
            "color_saturation"=> "0.0",
            "state"=> nil,
            "connectivity_status"=> "connected",
            "installation_status"=> nil,
      }
$LOC_DEVICES = {"Office" => ["TestDevice_1","TestDevice_2"],"Home" => ["TestDevice_3","TestDevice_4"], "Leeo Test" => ["TestDevice_5","TestDevice_6"]}

def switch_backend(app = nil)
  if (app == "leeo-cal") or (app == nil)
    $API_SERVER = "https://qa.leeo.com/api"
    $DATABASE_URL = "postgres://u2ersdnp6qdpsn:pakgqcu9ifdklle3p2b8rpmguba@ec2-107-21-202-219.compute-1.amazonaws.com:5542/d3vu4a4tm25ko5"
    return true
  elsif app == "leeo-test-cal"
    $API_SERVER = "https://test.leeo.com/api"
    $DATABASE_URL = "postgres://ucfqo90i9riabo:p66qf2i9r5t3uj998f1errp07a8@ec2-54-204-2-35.compute-1.amazonaws.com:5672/d608obt1cto2nr"
    return true
  elsif app == "leeo-eu-cal"  
    $API_SERVER = "https://eu-qa.leeo.com/api"
    return true
  elsif app == "leeo-eu-test-cal" 
    $API_SERVER = "https://eu-test.leeo.com/api"
    return true
  else
    return false
  end
end

def check_user_existing(operation)
  if $USER == nil
    $USER = User.new()
  end
  if !$user_created and operation == "create"
    $LOGGER.info("New user will be created")
    try_counter = 0
    while !$USER.isLoggedIn()
      $USER.email = "leeo.blstest+"+rand(100..900).to_s+"@gmail.com" 
      $USER.password = "asdfasdf"
      $USER.name = $NAME
      $USER.phone_number = $PHONE_NUMBER
      if $USER.create()
        $USER.sign_in()
        if $USER.isLoggedIn()
          $USER.update()
          $LOC_DEVICES.each do |loc, dev_arr|
            $USER.create_location(loc)
            location = $USER.find_location_by_name(loc)[0]
            location.parse($LOC_DATA)
            location.update()
            dev_arr.each do |dev|
              location.create_device(dev)
              device = location.find_device_by_name(dev)[0]
              device.parse($DEVICE_DATA)
              device.update()
            end
          end
        end
        $user_created = true
        return true
      else
        try_counter = try_counter+1
      end
      if try_counter > 10
        $LOGGER.warn("Cannot create user, test will be skipped")
        return false
      end 
    end  
  elsif $user_created and operation == "create"
    $LOGGER.info("User already created")
  elsif $user_created and operation == "remove"
    $LOGGER.info("User wil be removed")
    if $USER.isLoggedIn()
      $USER.delete()
    end
    $user_created = false
  end
end


if ENV["API"]
  if ENV["API"].include? "EU_"
    $PHONE_NUMBER = "+14123456782"
    $REGION = "PL"
  end 
else
  $PHONE_NUMBER = "4123456782"
  $REGION = "AK"
end


def check_defaults(email = nil, pass = nil)
  if email == "default"
    if ENV["USER"]
      email = ENV["USER"]
    else
#SETTING DEFAULT USER EMAIL
      email = "leeo.blstest+default@gmail.com"
    end
  end
  if pass == "default"
    if ENV["PASS"]
      pass = ENV["PASS"]
    else
#SETTING DEFAULT USER PASS
      pass = "asdfasdf"
    end
  end
  if email && pass
    return email, pass
  elsif email
    return email
  elsif pass
    return pass
  end
end
