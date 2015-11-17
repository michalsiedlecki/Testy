Given(/I click Alarm$/) do
  
  @menuPageObj= page(MenuPage).await
  @menuPageObj.touchDevice
  
end

Given(/I check temperature$/) do
  
  @devicePageObj= page(DevicePage).await
  @devicePageObj.checkTemperature(DATA[:temperatureCelsius], DATA[:temperatureFarenheit])
  
end

Given(/I check humidity$/) do
  
  @devicePageObj= page(DevicePage).await
  @devicePageObj.checkHumidity(DATA[:humidity])
  
end

Given(/I check message$/) do
  
  @devicePageObj= page(DevicePage).await
  @devicePageObj.checkAlert(DATA[:message])
  
end

Given(/I press light button$/) do
  
  @devicePageObj= page(DevicePage).await
  @devicePageObj.touchLight
  
end

Given(/I choose white/) do
  
  @lightPageObj= page(LightPage).await
  #@lightPageObj.white(DATA[:x], DATA[:y])
  @lightPageObj.white
  
end

Given (/I accept color/) do
  @lightPageObj= page(LightPage).await
  @lightPageObj.touchDone
end