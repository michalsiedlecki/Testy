class Duration < DroidEndomondo
  
  element(:okButton) { "Button id:'button1'" }
  
  
  trait(:trait) { okButton }
  
  action(:touchOkButton) { touch(okButton) }
  
  def change_time
    query("NumberPicker id:'HoursPicker'", { setValue: 10 })
    query("NumberPicker id:'MinutesPicker'", { setValue: 9 })
    query("NumberPicker id:'SecondsPicker'", { setValue: 8 })
    touchOkButton
  end
  
end