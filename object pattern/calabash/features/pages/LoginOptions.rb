class LoginOptions < DroidEndomondo
  element(:loginByGoogle) { "LoginButtonView id:'plus'" }
  element(:loginByFacebook) { "LoginButtonView id:'facebook'" }
  element(:loginByEmail) { "LoginButtonView id:'email'" }
  
  action(:touchLoginByGoogle) {touch(loginByGoogle)}
  action(:touchLoginByFacebook) {touch(loginByFacebook)}
  action(:touchLoginByEmail) {touch(loginByEmail)}
  
  trait(:trait) { loginByEmail }  
    
end