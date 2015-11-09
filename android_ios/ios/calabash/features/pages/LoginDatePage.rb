class LoginDatePage < DroidLeeo
  
  
  element(:logIn) { "button marked:'Button.log-in'"}
  element(:email) { "label marked:'Email'"}
  element(:password) { "label marked:'Password'"}
  
  action(:touchLogIn) {touch(logIn)}
  
  trait(:trait) { email }
  
  def loginFunction()
    puts "Dodano email" if query(email, {:setText => 'michal.siedlecki@blstream.com'})
    puts "Dodano haslo" if query(password, {:setText => 'endomondo22'})
    touchLogIn
  end
end