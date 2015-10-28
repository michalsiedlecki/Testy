module Endomondo
  module Menu
    class << self
      
      def assertExists
      
      end

      def assert
        wait { assertExists }
      end
      
       def challengeClick
        assert
        wait { text_exact("Challenges").click }
        challenges_page.assert
       end
       
      
    end
  end
end

module Kernel
  def menu_page
    Endomondo::Menu
  end
end
