module Endomondo
  module Login
    class << self
      
      def assertExists
        @login = find_element(:id, 'login')
      end
      
      def assert
        wait { assertExists }
      end
      
      def loginClick
        assert
        wait { @login.click }
        login_options_page.assert
      end
        
    end
  end
end

module Kernel
  def login_page
    Endomondo::Login
  end
end