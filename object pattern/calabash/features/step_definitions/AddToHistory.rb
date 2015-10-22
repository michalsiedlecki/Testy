Given(/I click Navigation Button$/) do
  
  @mainActivityObj.touchNavigationButton
end
Given(/I click History$/) do
  @navigationDrawerObj= page(NavigationDrawer).await
  @navigationDrawerObj.touchHistoryButton
 end

Given(/I click Add Button$/) do
  @historyObj = page(History).await
  @historyObj.touchPlusButton
end

Given(/I click Sport$/) do
  @manualEntryObj = page(ManualEntry).await
  @manualEntryObj.touchsportButton
  @selectSportObj= page(SelectSport).await
  @selectSportObj.touchSportButton
end

Given(/I want enter date and time$/) do
  @manualEntryObj.touchStartTimeButton
  @workoutDateObj= page(WorkoutDate).await
  @workoutDateObj.enterDate
  @HistoryTimeObj= page(HistoryStartTime).await
  @HistoryTimeObj.enterTime
end

Given(/I want click Duration$/) do
  @manualEntryObj.touchDurationButton
  @durationObj= page(Duration).await
  @durationObj.change_time
 end
Given(/I want click Distance$/) do
  @manualEntryObj.touchDistanceButton
  @distanceObj= page(Distance).await
  @distanceObj.enterTime
  
  @manualEntryObj.touchSaveButton
end
                
  
