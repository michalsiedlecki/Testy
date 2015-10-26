require_relative '../requires' # enable auto complete in RubyMine

describe "Verify if the user can change voice's language" do
  t 'spec' do
    
    login_page.loginClick
    login_options_page.loginWithEmailClick
    login_by_email_page.fillForm(USERS[:valid][:email], USERS[:valid][:password])
    login_by_email_page.loginClick
    main_activity_page.moreOptionsClick
    more_options_page.audioSettingsClick
    audio_settings_page.languagesAndVoicesClick
    select_text_page.speechSynthesisClick
    select_voice_page.speechSynthesisClick
    testV.testVoiceClick
    testV.selectVoiceClick
    
  end
end