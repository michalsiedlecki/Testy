class LoginPage < DroidLeeo
  element(:login) { "Button id:'welcome_login_button'"}
  
  
  action(:touchLogin) {touch(login)}
  
  trait(:trait) { login }
end