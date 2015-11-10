Given(/I click Home$/) do
  
  @menuPageObj= page(MenuPage).await
  @menuPageObj.touchHome
  
end

Given(/I change unit$/) do
  
  @homePageObj= page(HomePage).await
  @homePageObj.ChangeUnit
  
end