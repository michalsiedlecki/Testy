module Endomondo
  module Challenges
    class << self
      
      def assertExists
        @create = find_element(:xpath,"//*[@class='android.widget.TextView'and @text='Create']") 
        
        
      end

      def assert
        wait { assertExists }
      end
      
       def createChallengeClick
        assert
        wait { @create.click
          find_element(:id, 'newChallengeButton').click}
        #profile_page.assert
       end
       
      
    end
  end
end

module Kernel
  def challenges_page
    Endomondo::Challenges
  end
end
