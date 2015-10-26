module Endomondo
  module TestVoice
    class << self
      
      def assertExists
       @testVoice = find_element(:id, 'TestButton')
       @selectVoice = find_element(:id, 'SelectButton')
      end

      def assert
        wait { assertExists }
      end
      
       
       def testVoiceClick
        assert
        wait { @testVoice.click }
        sleep 2
        #profile_page.assert
       end
       
       def selectVoiceClick
        assert
        wait { @selectVoice.click }
        sleep 2
        #profile_page.assert
       end
      
    end
  end
end

module Kernel
  def testV
    Endomondo::TestVoice
  end
end