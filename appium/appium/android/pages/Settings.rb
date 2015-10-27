module Endomondo
  module Settings
    class << self
      
      def assertExists
        @profile = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Profile']") 
        @workoutSettings = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Workout Settings']")
      
        
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
       
       def workoutSettingsClick
        assert
        wait { @workoutSettings.click }
        workout_Page.assert
       end
      
    end
  end
end

module Kernel
  def settings_page
    Endomondo::Settings
  end
end