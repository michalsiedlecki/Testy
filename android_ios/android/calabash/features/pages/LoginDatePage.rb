class LoginDatePage < DroidLeeo
  
  
  element(:logIn) { "Button id:'login_button'"}
  element(:email) { "EditText id:'login_email'"}
  element(:password) { "EditText id:'login_password'"}
  element(:forgotPassword) { "TextView id:'login_forgot_password'"}
  
  action(:touchLogIn) {touch(logIn)}
  
  trait(:trait) { email }
  
  def loginFunction()
    puts "Dodano email" if query(email, {:setText => 'michal.siedlecki@blstream.com'})
    puts "Dodano haslo" if query(password, {:setText => 'endomondo22'})
    touchLogIn
  end
end