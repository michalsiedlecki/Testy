class LoginDatePage < DroidLeeo
  
  
  element(:logIn) { "button marked:'Button.log-in'"}
  element(:email) { "TextField marked:'TextField.email'"}
  element(:password) { "TextField marked:'TextField.password'"}
  
  
  trait(:trait) { email }
  
  def loginFunction(email1, password1)
    touch(email)
    fast_enter_text(email1)
    touch(password)
    fast_enter_text(password1)
    touch(logIn)
  end
end