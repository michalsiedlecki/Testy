require_relative '../requires' # enable auto complete in RubyMine

describe "Verify if the user can change training's options in MainActivity" do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.loginClick
    main_activity_page.sportMainButtonClick
    selectS.hikingButonClick
    main_activity_page.durationClick
    select_data_page.speedClick
    main_activity_page.workoutButtonClick
    
  end
end