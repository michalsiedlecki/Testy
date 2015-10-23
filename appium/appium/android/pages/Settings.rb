module Endomondo
  module Settings
    class << self
      
      def assertExists
        @profile = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Profile']") 
       
      
        
      end

      def assert
        wait { assertExists }
      end
      
       def profileClick
        assert
        wait {
          @profile.click
          #text_exact("Profile").click
          }
        profile_page.assert
       end
      
    end
  end
end

module Kernel
  def settings_page
    Endomondo::Settings
  end
end