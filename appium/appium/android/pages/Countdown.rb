module Endomondo
  module Countdown
    class << self
      
      def assertExists
        @off = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Off']")  
      end

      def assert
        wait { assertExists }
      end
        
      def offClick
        assert
        wait { @off.click }
        workout_Page.assert
      end
      
    end
  end
end

module Kernel
  def countdown_page
    Endomondo::Countdown
  end
end