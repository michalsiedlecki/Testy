require_relative '../requires' # enable auto complete in RubyMine

describe 'Verify if the user can login to the application with valid credencials' do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.loginClick
    main_activity_page.moreOptionsClick
    more_options_page.settingsClick
    settings_page.profileClick
    profile_page.birthdayClick
    birthday_page.changeDate
    
  end
end