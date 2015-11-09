Given(/I click menu$/) do
  
  @mainPageObj= page(MainPage).await
  @mainPageObj.touchMenu
  
end

Given(/I click My Account$/) do
  
  @menuPageObj= page(MenuPage).await
  @menuPageObj.touchMyAccount
  
end

Given(/I change number$/) do
  
  @accountPageObj= page(AccountPage).await
  @accountPageObj.ChangeNumber
  
end