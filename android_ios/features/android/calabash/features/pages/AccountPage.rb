class AccountPage < DroidLeeo
  
  element(:logOut) { "Button id:'log_out_button'"}
  element(:number) { "EditText id:'phone_number_info'"}
  element(:save) { "Button id:'save_button'"}
  
  action(:touchNumber) {touch(number)}
  action(:touchSave)  {touch(save)}
  action(:touchLogOut) {touch(logOut)}
  
  def ChangeNumber(number1, number2)
    touchNumber
    if number1 == query(number)[0]["text"]
      query(number, {:setText => number2})
    else
      query(number, {:setText => number1})
    end
    touchSave
  end
  
  trait(:trait) { number }
end