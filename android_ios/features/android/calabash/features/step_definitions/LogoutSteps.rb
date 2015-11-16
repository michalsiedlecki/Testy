Given(/I click Log In$/) do
  
  @loginPageObj= page(LoginPage).await
  @loginPageObj.touchLogin
  
end

Given(/I enter email and password$/) do
  
  @loginDatePageObj= page(LoginDatePage).await
  @loginDatePageObj.loginFunction(DATA[:email],DATA[:password])
  
end

Given(/I click Log Out$/) do
  
  @accountPageObj= page(AccountPage).await
  @accountPageObj.touchLogOut
  
end