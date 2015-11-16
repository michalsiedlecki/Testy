class LoginPage < DroidLeeo
  element(:login) { "button marked:'Button.log-in'"}
  
  def touchLogin
    touch(login)
  end
  
  trait(:trait) { login }
end