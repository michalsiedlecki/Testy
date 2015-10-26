module Endomondo
  module SelectData
    class << self
      
       
       
      
      def assertExists
        @speedButton = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Speed']")
        
      end

      def assert
        wait { assertExists }
      end
      
      def speedClick
        assert
        wait { @speedButton.click }
        main_activity_page.assert
      end
    end
  end
end

module Kernel
  def select_data_page
    Endomondo::SelectData
  end
end