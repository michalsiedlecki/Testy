require_relative '../requires' # enable auto complete in RubyMine

describe 'Verify if the user can login to the application with valid credencials' do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.login_click
    #workout_page.assert
    
  end
end