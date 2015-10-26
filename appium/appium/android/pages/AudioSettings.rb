module Endomondo
  module AudioSettings
    class << self
      
      def assertExists
       @languagesAndVoices = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Languages and Voices']") 
      end

      def assert
        wait { assertExists }
      end
      
       
       def languagesAndVoicesClick
        assert
        wait {@languagesAndVoices.click}
        select_text_page.assert
       end
      
    end
  end
end

module Kernel
  def audio_settings_page
    Endomondo::AudioSettings
  end
end