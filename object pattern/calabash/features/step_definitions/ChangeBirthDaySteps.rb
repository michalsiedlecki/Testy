Given(/I click Options$/) do
  
  @mainActivityObj.touchMoreOptions
  @moreOptionsObj= page(MoreOptions).await
end

Given(/I click Settings$/) do
  @moreOptionsObj.touchSettings
  @settingsObj = page(Settings).await
end

Given(/I click Profile$/) do
  @settingsObj.touchProfile
  @profileObj = page(Profile).await
end
  
Given(/I change date of birthday$/) do
  @profileObj.touchBdayButton
  @birthDayObj = page(BirthDay).await
  @birthDayObj.enterDate(USERS[:valid][:birthday])
end            
  
