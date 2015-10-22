class Settings < DroidEndomondo
  
  element(:profile) { "RobotoTextView text:'Profile'" }
  element(:subscription) { "RobotoTextView text:'Subscription'" }
  element(:workoutSettings) { "RobotoTextView text:'Workout Settings'" }
  element(:audioSettings) { "RobotoTextView text:'Audio Settings'" }
  element(:smartwatches) { "RobotoTextView text:'Smartwatches'" }
  element(:accessorySettings) { "RobotoTextView text:'Accessory Settings'" }
  element(:connectAndShare) { "RobotoTextView text:'Connect & Share'" }
  element(:notificationSettings) { "RobotoTextView text:'Notification Settings'" }
  element(:privacy) { "RobotoTextView text:'Privacy'" }
  element(:locationSettings) { "RobotoTextView text:'Location Settings'" }
  element(:whatsNew) { "RobotoTextView text:'What\'s new'" }
  element(:about) { "RobotoTextView text:'About'" }

  action(:touchProfile) { touch(profile) }
  action(:touchSubscription) { touch(subscription) }
  action(:touchWorkoutSettings) { touch(workoutSettings) }
  action(:touchSubscription) { touch(audioSettings) }
  action(:touchAudioSettings) { touch(smartwatches) }
  action(:touchAccessorySettings) { touch(accessorySettings) }
  action(:touchConnectAndShare) { touch(connectAndShare) }
  action(:touchNotificationSettings) { touch(notificationSettings) }
  action(:touchPrivacy) { touch(privacy) }
  action(:touchLocationSettings) { touch(locationSettings) }
  action(:touchWhatsNew) { touch(whatsNew) }
  action(:touchAbout) { touch(about) }
  
  trait(:trait) { profile }
  
end