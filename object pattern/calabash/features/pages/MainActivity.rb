class MainActivity < DroidEndomondo
  
  element(:motivationMainButton) { "MotivationMainButton id:'MotivationMainButton'" }
  element(:sportMainButton) { "SportMainButton id:'SportMainButton'" }
  element(:workoutButton) { "ImageButton id:'ButtonStartPauseFront'" }
  element(:moreOptions) { "d ContentDescription:'More options'" }
  element(:music) { "ActionMenuItemView ContentDescription:'Music'" }
  element(:inbox) { "ActionMenuItemView ContentDescription:'Inbox'" }
  element(:navigationButton) { "ImageButton ContentDescription:'Navigation drawer'" }
  element(:countdownText) { "RobotoTextView id:'ButtonCountdownStopText'" }
  element(:stopCountdown) { "ImageButton id:'ButtonCountdownStopFront'" }
  
  trait(:trait) { moreOptions }
  
  action(:touchMotivationMainButton) { touch(motivationMainButton) }
  action(:touchSportMainButton) { touch(sportMainButton) }
  action(:touchWorkoutButton) { touch(workoutButton) }
  action(:touchMoreOptions) { touch(moreOptions) }
  action(:touchNavigationButton) { touch(navigationButton) }
  action(:touchMusic) { touch(music) }
  action(:touchInbox) { touch(inbox) }
  action(:touchStopCountdown) { touch(stopCountdown) }
  
  
end