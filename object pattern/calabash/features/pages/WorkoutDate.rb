class WorkoutDate < DroidEndomondo
  
  element(:doneButton) { "Button id:'button1'" }
  
  action(:touchDoneButton) { touch(doneButton) }

  trait(:trait) { doneButton }
  
  def enterDate
    set_date("DatePicker id:'date_picker'", "20-10-2015")
    touchDoneButton
  end
end