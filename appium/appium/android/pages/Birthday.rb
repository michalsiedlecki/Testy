

module Endomondo
  module Birthday
    class << self
      
      def assertExists
        @pickers = find_elements(:xpath,"//*[@class='android.widget.NumberPicker']")
        @day = @pickers[1] 
        @month = @pickers[0]
        @year = @pickers[2]
        @okButton = find_element(:xpath,"//*[@class='android.widget.Button'and @text='Ok']")
      end

      def assert
        wait { assertExists }
      end
      
      def swipe_element(element, offset, duration)
        sleep 1
        start_x = element.location.x
        start_y = element.location.y
        end_x = start_x 
        end_y = start_y + offset
        swipe({'duration': duration, 'start_x': start_x, 'start_y': start_y, 'end_x': end_x, 'end_y': end_y})
      end
      def changeDate
        assert
        wait {
          
          swipe_element(@day,1000,500)
          swipe_element(@month,1000,500)
          swipe_element(@year,1000,500)
          @okButton.click
                      
            }
        profile_page.assert
        
      end
      
    end
  end
end

module Kernel
  def birthday_page
    Endomondo::Birthday
  end
end