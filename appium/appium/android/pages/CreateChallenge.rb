module Endomondo
  module CreateChallenge
    class << self
      
      def assertExists
        @addName = find_element(:id, 'challenge_name_input')
        @goal = find_element(:id, 'info_picker_description')
       # @startDate = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Oct 28, 2015']")
       # @endDate = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Nov 28, 2015']")
        #@makeButton = find_element(:id, 'newChallengeButton')
        
        
      end

      def assert
        wait { assertExists }
      end
      
       def addNameClick
        assert
        wait { @addName.type("Test") }
       end
       
       def goalClick
        assert
        wait { @goal.click }
        goal_page.assert
       end
       
       def sportClick
        assert
        wait { find_element(:xpath,"//*[@class='android.widget.TextView'and @text='All Sports']").click }
        selectS.assert
       end
      
      def startClick
        assert
        wait { find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Oct 28, 2015']").click }
        birthday_page.assert
      end
      
    end
  end
end

module Kernel
  def create_challenge_page
    Endomondo::CreateChallenge
  end
end
