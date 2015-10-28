module Endomondo
  module SelectSport
    class << self
      
       
       
      
      def assertExists
        @hikingButton = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Hiking']")
        
      end

      def assert
        wait { assertExists }
      end
      
       def hikingButonClick
        assert
        wait { @hikingButton.click }
        main_activity_page.assert
       end
      def hikingButonChallengeClick
        assert
        wait { @hikingButton.click
          find_element(:xpath,"//*[@class='android.widget.Button'and @text='Done']").click}
        create_challenge_page.assert
      end
      
    end
  end
end

module Kernel
  def selectS
    Endomondo::SelectSport
  end
end