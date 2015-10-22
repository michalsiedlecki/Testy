Given(/I want to be logged in$/) do
  
  @loginObj= page(Login).await
  @loginObj.touchLogin
  @loginOptionsObj = page(LoginOptions).await
  @loginOptionsObj.touchLoginByEmail
  @loginByEmailScreenObj = page(LoginByEmailScreen).await
  @loginByEmailScreenObj.loginFunction(USERS[:valid][:email], USERS[:valid][:password])
  @mainActivityObj = page(MainActivity).await
end