module Endomondo
  module LoginByEmail
    class << self
      
      
      
      def assertExists
        @emailField = find_element(:id, 'email')
        @passwordField = find_element(:id, 'password')
        @loginButton = find_element(:id, 'commit')
      end

      def assert
        wait { assertExists }
      end
      
      def fillForm(email, password)
        assert
        wait { @emailField.type(email) }
        wait { @passwordField.type(password)}
      end
      
       def loginClick
        assert
        wait { @loginButton.click }
       end
      
    end
  end
end

module Kernel
  def login_by_email_page
    Endomondo::LoginByEmail
  end
end