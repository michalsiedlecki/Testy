Given(/I click Home Information$/) do
  
  @homePageObj= page(HomePage).await
  @homePageObj.touchHomeInformation
  
end

Given(/I change street$/) do
  
  @homeInformationPageObj= page(HomeInformationPage).await
  @homeInformationPageObj.ChangeAddress(DATA[:street1],DATA[:street2])
  
end

Given(/Exit to Menu$/) do
  
  @homePageObj= page(HomePage).await
  @homePageObj.touchBack
  
end



