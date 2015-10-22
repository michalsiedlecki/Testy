class HistoryStartTime < DroidEndomondo
  
  element(:doneButton) { "Button id:'button1'" }
  
  action(:touchDoneButton) { touch(doneButton) }

  trait(:trait) { doneButton }
  
  def enterTime
    set_time("TimePicker id:'time_picker'", "10:00")
    touchDoneButton
  end
end