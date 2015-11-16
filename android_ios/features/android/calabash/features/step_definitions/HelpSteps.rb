Given(/I click Help$/) do
  
  @menuPageObj= page(MenuPage).await
  @menuPageObj.touchHelp
  
end

Given(/I click Done$/) do
  
  @helpPageObj= page(HelpPage).await
  @helpPageObj.touchDone
  
end