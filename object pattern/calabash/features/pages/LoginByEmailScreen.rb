class LoginByEmailScreen < DroidEndomondo
  
  element (:emailTextField) { "AutoCompleteTextView id:'email'"}
  element (:passwordTextField) { "TintEditText id:'password'" }
  element (:loginButton) { "LoginButtonView id:'commit'" }
  
  action(:touchLoginButton) { touch(loginButton) }
  
  trait(:trait) { loginButton }
  
  def loginFunction(email, password)
    query(emailTextField, {:setText => email})
    query(passwordTextField, {:setText => password})
    touchLoginButton
  end
  
  
end