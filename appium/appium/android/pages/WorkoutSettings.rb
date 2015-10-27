module Endomondo
  module WorkoutSettings
    class << self
      
      def assertExists
        @countdown = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Countdown']")  
      end

      def assert
        wait { assertExists }
      end
        
      def countdownClick
        assert
        wait { @countdown.click }
        countdown_page.assert
      end
      
    end
  end
end

module Kernel
  def workout_Page
    Endomondo::WorkoutSettings
  end
end