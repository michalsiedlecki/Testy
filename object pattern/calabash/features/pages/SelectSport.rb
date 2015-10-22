class SelectSport < DroidEndomondo
  
  element(:sportButton) { "RobotoTextView text:'Hiking'" }
  
  trait(:trait) { sportButton }
  
  action(:touchSportButton) { touch(sportButton) }
end