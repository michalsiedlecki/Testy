class ManualEntry < DroidEndomondo
  
  element(:sportButton) { "RobotoTextView text:'Sport'" }
  element(:startTimeButton) { "RobotoTextView text:'Start time'" }
  element(:durationButton) { "RobotoTextView text:'Duration'" }
  element(:distanceButton) { "RobotoTextView text:'Distance'" }
  element(:saveButton) { "Button id:'saveButton'" }
  
  trait(:trait) { durationButton }
  
  action(:touchsportButton) { touch(sportButton) }
  action(:touchStartTimeButton) { touch(startTimeButton) }
  action(:touchDurationButton) { touch(durationButton) }
  action(:touchDistanceButton) { touch(distanceButton) }
  action(:touchSaveButton) { touch(saveButton) }
  
end