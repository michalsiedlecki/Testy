

module Endomondo
  module Birthday
    class << self
      
      def assertExists
        @day = find_element(:xpath,"//*[@class='android.widget.EditText'and @text='20']")
        @month = find_element(:xpath,"//*[@class='android.widget.EditText'and @text='Nov']")
        @year = find_element(:xpath,"//*[@class='android.widget.EditText'and @text='1988']")
        @okButton = find_element(:xpath,"//*[@class='android.widget.Button'and @text='Ok']")
      end

      def assert
        wait { assertExists }
      end
      
       def changeDate
        assert
        wait {
               @day.send_keys("25")
               @month.send_keys("Dec")
               @year.send_keys("2000")
               @okButton.click
               sleep(10)
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