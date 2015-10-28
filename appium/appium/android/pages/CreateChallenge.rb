module Endomondo
  module CreateChallenge
    class << self
      
      def assertExists
        @addName = find_element(:id, 'challenge_name_input')        
        @pickers = find_elements(:id, "info_picker_description")
        @goal = @pickers[0] 
        @addSport = @pickers[1]
        @startDate = @pickers[2]
        @endDate = @pickers[3]
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
        wait { @addSport.click }
        selectS.assert
       end
      
      def startClick
        assert
        wait { @startDate.click }
        birthday_page.assert
      end
      
       def doneClick
        assert
        wait { find_element(:id, 'newChallengeButton').click }
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
