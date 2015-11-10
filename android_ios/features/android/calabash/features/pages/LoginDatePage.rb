class LoginDatePage < DroidLeeo
  
  
  element(:logIn) { "Button id:'login_button'"}
  element(:emailText) { "EditText id:'login_email'"}
  element(:passwordText) { "EditText id:'login_password'"}
  element(:forgotPassword) { "TextView id:'login_forgot_password'"}
  
  
  
  trait(:trait) { emailText }
  
  def loginFunction(email1, password1)
    puts "Dodano email" if query(emailText, {:setText => email1})
    puts "Dodano haslo" if query(passwordText, {:setText => password1})
    touch(logIn)
  end
end