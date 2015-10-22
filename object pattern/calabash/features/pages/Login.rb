class Login< DroidEndomondo
  element(:login) { "LoginButtonView id:'login'" }
  element(:signUp) { "LoginButtonView id:'signup'" }
  
  action(:touchLogin) {touch(login)}
  action(:touchSignUp) {touch(signUp)}
  
  trait(:trait) { signUp }
  
end