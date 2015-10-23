module Endomondo
  module MoreOptions
    class << self
      
      def assertExists
       # @audioSettings = find_element(:text, 'Audio Settings')
       @settings = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Settings']") 
       # @tutorial = find_element(:text, 'Tutorial')
       # @exit = find_element(:text, 'Exit')
        
      end

      def assert
        wait { assertExists }
      end
      
       def settingsClick
        assert
        wait {
          @settings.click
          #text_exact("Settings").click
          }
        settings_page.assert
       end
      
    end
  end
end

module Kernel
  def more_options_page
    Endomondo::MoreOptions
  end
end