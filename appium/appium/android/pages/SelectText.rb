module Endomondo
  module SelectText
    class << self
      
      def assertExists
       @speechSynthesis = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Android SpeechSynthesis']") 
      end

      def assert
        wait { assertExists }
      end
      
       
       def speechSynthesisClick
        assert
        wait {@speechSynthesis.click}
        select_voice_page.assert
       end
      
    end
  end
end

module Kernel
  def select_text_page
    Endomondo::SelectText
  end
end