module Endomondo
  module MainActivity
    class << self
      
       
       
      
      def assertExists
        @durationButton = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Duration']")
        @motivationMainButton = find_element(:id, 'MotivationMainButton')
        @sportMainButton = find_element(:id, 'SportMainButton')
        @workoutButton = find_element(:id, 'ButtonStartPauseBackground')
        @moreOptionsButton = find_element(:xpath,"//*[@class='android.widget.ImageView'and @content-desc='More options']")
        
      end

      def assert
        wait { assertExists }
      end
      
       def moreOptionsClick
        assert
        wait { @moreOptionsButton.click }
        more_options_page.assert
       end
      
      def sportMainButtonClick
        assert
        wait { @sportMainButton.click }
        selectS.assert
      end
      
      def durationClick
        assert
        wait { @durationButton.click }
        select_data_page.assert
      end
      
      def workoutButtonClick
        assert
        wait { @workoutButton.click }
      end
    end
  end
end

module Kernel
  def main_activity_page
    Endomondo::MainActivity
  end
end