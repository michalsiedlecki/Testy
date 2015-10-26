

module Endomondo
  module Birthday
    class << self
      
      def assertExists
        @day = find_element(:xpath,"//*[@class='android.widget.NumberPicker'and @text='21']")
        @month = find_element(:xpath,"//*[@class='android.widget.NumberPicker'and @text='Dec]")
        @year = find_element(:xpath,"//*[@class='android.widget.NumberPicker'and @text='1989']")
        @okButton = find_element(:xpath,"//*[@class='android.widget.Button'and @text='Ok']")
      end

      def assert
        wait { assertExists }
      end
      
      def changeDate
        assert
        wait {
          
          swipe({'duration': 100, 'start_x': @year.location.x, 'start_y': @year.location.y, 'end_x': 10, 'end_y': @year.location.y})
          
               #@day.click
               #@month.click
               #@year.click
               #@okButton.click
               #sleep(10)
               #find_element(:xpath,"//*[@class='android.widget.NumberPicker'and @index='2']").sendKeys("2010");
            }
        
      end
      
    end
  end
end

module Kernel
  def birthday_page
    Endomondo::Birthday
  end
end