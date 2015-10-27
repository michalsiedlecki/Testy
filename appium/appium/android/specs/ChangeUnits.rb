require_relative '../requires' # enable auto complete in RubyMine

describe 'Verify if the user can change units' do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.loginClick
    main_activity_page.moreOptionsClick
    more_options_page.settingsClick
    settings_page.profileClick
    profile_page.unitsClick
    
  end
end