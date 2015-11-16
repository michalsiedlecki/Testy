require "pubnub_node"
require "test/unit"

class PubNubNodeTests < Test::Unit::TestCase
  PUBLISH_KEY = "pub-c-b8f0aa53-b914-4af4-ab62-2f35d53b6aea"
  SUBSCRIBE_KEY = "sub-c-d28e2f60-4c64-11e4-9e3d-02ee2ddab7fe"
  ORIGIN = "pubsub.pubnub.com"
  CHANNEL = "customMessageTestChannel"
  
  class Handler
    attr_accessor :waitStatus, :lastMsg
    
    def initialize
      @waitLock = Mutex.new
      @waitCond = ConditionVariable.new
      @waitStatus = true
    end
    
    def some_custom__message__handler(msg)
      @lastMsg = msg
      @waitLock.synchronize {
        @waitStatus = false
        @waitCond.signal
      }
    end
    
    def wait
      @waitLock.synchronize {
        if @waitStatus
          @waitCond.wait(@waitLock, 30)
        end
      }
    end
  end

  @@handler = Handler.new
  @@pubNubNode = NightlightEmulator::PubNubNode.new(PUBLISH_KEY, SUBSCRIBE_KEY, ORIGIN, @@handler)

  def test_customMessage
    @@handler.waitStatus = true
    @@pubNubNode.connect(CHANNEL)

    msg = {
      :type => "some_custom-message", 
      :data => "testString"
    }
    @@pubNubNode.sendMsg(msg)
    @@handler.wait    
    assert_equal(false, @@handler.waitStatus)
    assert_equal(false, @@handler.lastMsg.nil?)
    assert_equal("testString", @@handler.lastMsg["data"])
   
    @@pubNubNode.disconnect(CHANNEL)
  end
end
