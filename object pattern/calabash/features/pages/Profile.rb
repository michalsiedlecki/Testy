class Profile < DroidEndomondo
  
  element(:saveButton) { "Button text:'Save'" }
  element(:logoutButton) { "ImageView id:'ButtonIcon'" }
  element(:bdayButton) { "SettingsButton id:'BdaySettingsButton'"}
  
  action(:touchSaveButton) { touch(saveButton) }
  action(:touchLogoutButton) { touch(logoutButton) }
  action(:touchBdayButton) { touch(bdayButton) }
  
  trait(:trait) { bdayButton }
  
end