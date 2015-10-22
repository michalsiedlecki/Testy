class History < DroidEndomondo
  
  element(:plusButton) { "ImageButton id:'create_workout_fab'" }
  
  trait(:trait) { plusButton }
  
  action(:touchPlusButton) { touch(plusButton) }
  
end