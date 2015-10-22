class BirthDay < DroidEndomondo
  
  element(:datePicker) { "DatePicker id:'DatePicker'" }
  element(:ok) { "Button id:'Button'"}
  
  action(:touchOk) { touch(ok) }
  
  def enterDate(date)
    set_date("DatePicker id:'DatePicker'", date)
    touchOk
  end
  trait(:trait) { ok }
  
end