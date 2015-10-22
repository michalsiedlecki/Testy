Given(/I want change my birthday$/) do
  
  @mainActivityObj.touchMoreOptions
  @moreOptionsObj= page(MoreOptions).await
  @moreOptionsObj.touchSettings
  @settingsObj = page(Settings).await
  @settingsObj.touchProfile
  @profileObj = page(Profile).await
  @profileObj.touchBdayButton
  @birthDayObj = page(BirthDay).await
  @birthDayObj.enterDate(USERS[:valid][:birthday])
                
  
end