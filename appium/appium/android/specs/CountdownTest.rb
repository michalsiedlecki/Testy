require_relative '../requires' # enable auto complete in RubyMine

describe 'Verify if the user can change birthday' do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.loginClick
    main_activity_page.moreOptionsClick
    more_options_page.settingsClick
    settings_page.workoutSettingsClick
    workout_Page.countdownClick
    countdown_page.offClick
    
  end
end