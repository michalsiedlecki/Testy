module Endomondo
  module Goal
    class << self
      
      def assertExists
        @mostMiles = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Most Miles']")
      end

      def assert
        wait { assertExists }
      end
      
       def goalClick
        assert
        wait { @mostMiles.click }
        create_challenge_page.assert
       end
       
      
    end
  end
end

module Kernel
  def goal_page
    Endomondo::Goal
  end
end
