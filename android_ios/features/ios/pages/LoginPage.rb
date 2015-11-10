class LoginPage < DroidLeeo
  element(:login) { "button marked:'Button.log-in'"}
  
  action(:touchLogin) {touch(login)}
  
  trait(:trait) { login }
end