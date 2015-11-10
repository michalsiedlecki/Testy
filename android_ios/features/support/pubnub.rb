require 'pubnub'

$my_logger = Logger.new(STDOUT)
$my_logger.level = Logger::WARN


def pubnub_connect
  create_connect = Pubnub.new(
      :subscribe_key    => $SUB_KEY,
      :publish_key      => $PUB_KEY,
      :origin           => $ORIGIN,
      :error_callback   => lambda { |msg|puts "Error callback says: #{msg.inspect}"},
      :connect_callback => lambda { |msg|puts "CONNECTED: #{msg.inspect}"},
      :logger => $my_logger
    )
  return create_connect
end

def pubnub_subscribe(pubnub, channel)
  pubnub.subscribe(:channel => channel, :http_sync => true)
end

def pubnub_send_sensors(pubnub, channel, temp, humid)
  time = Time.now.to_i
  #puts "time is "+time.to_s
  msg = '{"type":"streaming","version":"Leeo NightLight LNL9ZA1CA 1.0-17","sensor_data":[{"type":"Temperature","value":' + temp.to_s + ',"raw":38.5861279296875,"time":' + time.to_s + ',"uptime":1},{"type":"Humidity","value":' + humid.to_s + ',"raw":15.236419677734375,"time":'+time.to_s+',"uptime":1}]}'
  cb = lambda { |envelope| puts envelope.message }
  pubnub.publish(:message => msg, :channel => channel, :callback => cb, :http_sync => true)
end
