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
       
       def unitsClick
        assert
        wait { scroll_to("Miles").click
              find_element(:id, 'Button').click
          }
        end
        
        def SaveClick
          assert
          wait { find_element(:id, 'Button').click }
        end
        
       
      
    end
  end
end

module Kernel
  def profile_page
    Endomondo::Profile
  end
end