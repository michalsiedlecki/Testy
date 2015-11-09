Given(/I click Home Information$/) do
  
  @homePageObj= page(HomePage).await
  @homePageObj.touchHomeInformation
  
end

Given(/I change street$/) do
  
  @homeInformationPageObj= page(HomeInformationPage).await
  @homeInformationPageObj.ChangeAddress
  
end



