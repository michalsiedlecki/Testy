class Distance < DroidEndomondo
  
  element(:doneButton) { "Button id:'button1'" }
  
  action(:touchDoneButton) { touch(doneButton) }

  trait(:trait) { doneButton }
  
  def enterTime
    query("NumberPicker id:'MajorPicker'", setValue:1)
    query("NumberPicker id:'MinorPicker'", setValue:3)
    touchDoneButton
  end
end
    