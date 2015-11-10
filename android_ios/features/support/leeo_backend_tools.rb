
require 'curb'
require 'json'

$saved_alarms = []

def string_to_hash(string, multi=false)
  if multi 
    s_arr = Array.new
    string.split('},').each { |str| s_arr.push(str) }
    d_arr = Array.new
    s_arr.each do |value|
      d_hash = {}
      value.gsub!(/[^0-9A-Za-z:,-]/, '')
      value.split(',').each do |pair|
        key,value = pair.split(/:/)
        d_hash[key] = value
      end
      d_arr.push($d_hash)
    end
    return  d_arr
  else
    string.gsub!(/[^0-9A-Za-z:,-]/, '')
    hash = {}
    string.split(',').each do |pair|
      key,value = pair.split(/:/)
      hash[key] = value
    end
    return hash
  end
end

def api_get(token, path, params, multi=false)
  http = Curl::Easy.new
  http.headers = "X-Api-Auth-Token: #{token}" 
  http.url = "#{$API_SERVER}/#{path}?#{params}"
  http.perform
  return string_to_hash(http.body_str, multi)
end

def api_post(path, param, token=nil)
  http = Curl::Easy.new
  if token != nil
    http.headers = "X-Api-Auth-Token: #{token}" 
  end
  http.url = "#{$API_SERVER}#{path}"
  http.post(param)
  output = string_to_hash(http.body_str)
  return http.response_code, output 
end

def api_put(path, param, token=nil)
  http = Curl::Easy.new
  if token != nil
    http.headers['X-Api-Auth-Token'] = token
  end
  http.url = "#{$API_SERVER}#{path}"
  http.put JSON.generate(param)
  output = string_to_hash(http.body_str)
  return http.response_code, output 
end

def api_del(path, token=nil)
  http = Curl::Easy.new
  if token != nil
    http.headers = "X-Api-Auth-Token: #{token}"
  end
  http.url = "#{$API_SERVER}#{path}"
  http.delete = true
  http.perform
  return http.response_code
end
  
def login(email, pass)
  path = "/users/sign_in"
  param = Curl::PostField.content('email', email), Curl::PostField.content('password', pass)
  response, output = api_post(path, param)
  if response == 201
    puts "Signed in as user #{email} with id #{output['userid']}" 
    return output
  else
    puts param, output
  end 
end

def add_device (token)
  path = "/devices"
  param = "type=Nightlight"
  response, output = api_post(path, param, token)
  if response == 201
    puts "Device created" 
    return output
  elsif http.response_code == 401  
    puts "Response is #{response}, and output is #{output}"
  end 
end

def add_location(token, loc_name)
  path = "/locations" 
  param = "name=#{loc_name}"
  response, output = api_post(path, param, token)     
  if response == 201
    puts "location named #{loc_name} created" 
    return output
  elsif http.response_code == 401  
    puts "Response is #{response}, and output is #{output}"
  end 
end

def update_device(token, software_ver, device_token, location_id, device_id, dev_name)

  channel_id=(0...25).map { ('a'..'z').to_a[rand(26)] }.join
  serial=(0...5).map { ('a'..'z').to_a[rand(26)] }.join

  path = "/devices/#{device_id}"    
    param = {}
    param["id"] = device_id
    param["software_version"] = software_ver
    param["name"] = dev_name
    param["serial_number"] = serial
    param["type"] = "Nightlight"
    param["location_id"] = location_id
    param["channel"] = channel_id
    param["pir_enabled"] = "false"
    param["als_enabled"] = "false"
    param["color_hue"] = "0.0"
    param["color_value"] = "1.0"
    param["color_saturation"] = "0.0"
    param["device_token"] = device_token

  response, output = api_put(path, param, token)
  puts "update device response code #{response}"
    if response == 200
    puts "device #{device_id} updated withc data #{param}"
  else  
    puts "device #{device_id} not updated!!"
    end
  return response
end



# $API_SERVER = "http://eu-qa.leeo.com/api" 
# user_login = login("leeo.blstest+2@gmail.com", "asdfasdf")
# alarm = trigger_alarm(user_login['token'], user_login['userid'],'',"smoke")
# alarm = trigger_alarm(user_login['token'], user_login['userid'],'',"co")
# alarm = trigger_alarm(user_login['token'], user_login['userid'],'',"sound")
# dismiss_alarm(user_login['token'])  

  