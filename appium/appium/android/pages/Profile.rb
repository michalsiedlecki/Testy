module Endomondo
  module Profile
    class << self
      
      def assertExists
        @birthdayButton = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Date of Birth']")  
      end

      def assert
        wait { assertExists }
      end
      
       def birthdayClick
        assert
        wait { @birthdayButton.click }
        
       end
      
    end
  end
end

module Kernel
  def profile_page
    Endomondo::Profile
  end
end