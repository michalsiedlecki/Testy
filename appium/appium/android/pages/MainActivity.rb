module Endomondo
  module MainActivity
    class << self
      
       
       
      
      def assertExists
        @motivationMainButton = find_element(:id, 'MotivationMainButton')
        @sportMainButton = find_element(:id, 'SportMainButton')
        @workoutButton = find_element(:id, 'ButtonStartPauseFront')
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
      
    end
  end
end

module Kernel
  def main_activity_page
    Endomondo::MainActivity
  end
end