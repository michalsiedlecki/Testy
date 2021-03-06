require_relative '../requires' # enable auto complete in RubyMine

describe "Verify if the user can't make new challenge if he enter wrong start date" do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.loginClick
    main_activity_page.navigationButtonClick
    menu_page.challengeClick
    challenges_page.createChallengeClick
    create_challenge_page.addNameClick
    create_challenge_page.goalClick
    goal_page.goalClick
    create_challenge_page.sportClick
    selectS.hikingButonChallengeClick
    create_challenge_page.startClick
    birthday_page.changeChallengeDate
    create_challenge_page.doneClick
  end
end