module Endomondo
  module LoginOptions
    class << self
      
      def assertExists
        @loginWithEmail = find_element(:id, 'email')
      end

      def assert
        wait { assertExists }
      end
      
      def loginWithEmailClick
        assert
        wait { @loginWithEmail.click }
        login_by_email_page.assert
      end
    end
  end
end

module Kernel
  def login_options_page
    Endomondo::LoginOptions
  end
end