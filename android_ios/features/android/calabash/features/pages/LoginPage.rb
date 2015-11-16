class LoginPage < DroidLeeo
  element(:login) { "Button id:'welcome_login_button'"}
  
  def touchLogin
    touch(login)
  end
  
  trait(:trait) { login }
end