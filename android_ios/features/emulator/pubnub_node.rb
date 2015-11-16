load "device_info.rb"
load "device_state.rb"
load "emu_logger.rb"
require "pubnub"

module NightlightEmulator
  
  # PubNubNode wraps Leeo Nightlight specific PubNub communication (publish and subscribe).
  # During initialization, beside standard PubNub parameters, it also takes reference to objectc
  # that will handle specific messages.
  # PubNubNode use reflection to find public methods that handles specific messags.
  # To add method that will handle message of specific type, just add public method
  # named with following convention:
  # <em>message__ type__handler(msg)</em> - where message 'type' is type field value, with '-' replaced by '__' (two underscores)
  #                             and msg is Hash object obtained from parsing recived JSON message.
  # Example: To handle <em>{"type":"start-streaming"}</em> message
  # implement <em>start__ streaming__handler(msg)</em> method.
  # Note: __handelr methods are called from different threads, so remember about synchronizing resources.
  class PubNubNode
    # Perform basic setup and search for _handler methods in handlerObject.
    # Params:
    # +publishKey+:: Publish key.
    # +subscribeKey+:: Subscribe key.
    # +origin+:: Origin url.
    # +handlerObject+:: Object which implements _handler methods.
    def initialize(publishKey, subscribeKey, origin, handlerObject)
      @pubNub = Pubnub.new(
      :publish_key => publishKey,
      :subscribe_key => subscribeKey,
      :origin  => origin,
      :error_callback => method(:errHandler)
      )
      @handler = handlerObject
      @handlerMethods = Hash.new
      for method in @handler.public_methods(true)
        if method.to_s.end_with?("_handler")
          parts = method.to_s.split("__")
          parts.pop
          @handlerMethods[parts.join("-")] = method
        end
      end
    end
    
    # Starts subscribing given channel.
    # Params:
    # +channel+:: Channel name.
    def connect(channel)
      $LOG.info("Connecting to #{channel} channel.")
      @channel = channel
      @pubNub.subscribe(
      :channel => @channel,
      :callback => method(:msgHandler),
      :http_sync => true
      )
      @pubNub.subscribe(
      :channel => @channel,
      :callback => method(:msgHandler),
      :http_sync => false
      )
    end

    # Stops subscribing given channel.
    # Params:
    # +channel+:: Channel name.
    def disconnect(channel)
      $LOG.info("Disconnecting from #{channel} channel.")
      @pubNub.unsubscribe(
        :channel => @channel,
        :http_sync => true
      )
    end
    
    # Send device SW version.
    # Params:
    # +devInfo+:: +DeviceInfo+ object.
    def sendInfo(devInfo)
      msg = {
        :type => "info",
        :version => devInfo.swVersion
      }
      sendMsg(msg)
    end
    
    # Send info-connected message.
    def sendInfoConnected()
      msg = {
        :type => "info", 
        :connected => "yes"
      }
      sendMsg(msg)
    end
    
    # Send device color chaned message.
    # Params:
    # +devInfo+:: +DeviceInfo+ object.
    # +color+:: HSV collor  array.
    def sendUserColor(devInfo, color)
      msg = {
        :type => "user-color", 
        :device_id => devInfo.deviceId,
        :user_color => {
          :hue => color[0],
          :saturation => color[1],
          :value => color[2]
        }
      }
      sendMsg(msg)
    end
    
    # Send data streaming message.
    # Params:
    # +devInfo+:: +DeviceInfo+ object.
    # +devState+:: +DeviceState+ object.
    def sendStreaming(devInfo, devState)
      msg = {
        :type => "streaming", 
        :version => devInfo.swVersion,
        :sensor_data => [
          {
            :type => "Temperature", 
            :value => devState.temperature,
            :time => Time.now.to_i
          },
          {
            :type => "Humidity", 
            :value => devState.humidity, 
            :time => Time.now.to_i
          }
        ] 
      }
      sendMsg(msg)
    end
    
    # Serialize message to JSON and publish
    # Params:
    # +msg+:: +Hash+ message object.
    # +devState+:: +DeviceInfo+ object.
    def sendMsg(msg)
      @pubNub.publish(:message => msg, :channel => @channel, :http_sync => true)
    end
    
    private

    def errHandler(e)
      $LOG.error("PubNub connection error! #{e.inspect}")
    end
    
    def msgHandler(env)
      msg = env.message
      if !msg.nil?
        msgType = msg["type"]
        # If handlerObject implements given type message handler, then call it.
        if !msgType.nil? and @handlerMethods.include?(msgType)
          $LOG.debug("Handling #{msgType} messsage.")
          @handler.public_send(@handlerMethods[msgType], msg)
        end
      end
    end
  end
end
