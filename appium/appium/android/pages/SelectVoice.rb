module Endomondo
  module SelectVoice
    class << self
      
      def assertExists
       @german = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='German']") 
      end

      def assert
        wait { assertExists }
      end
      
       
       def speechSynthesisClick
        assert
        wait {@german.click}
        testV.assert
       end
      
    end
  end
end

module Kernel
  def select_voice_page
    Endomondo::SelectVoice
  end
end