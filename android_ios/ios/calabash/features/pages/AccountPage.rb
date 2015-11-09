class AccountPage < DroidLeeo
  
  element(:logOut) { "Button id:'log_out_button'"}
  element(:number) { "EditText id:'phone_number_info'"}
  element(:save) { "Button id:'save_button'"}
  
  action(:touchNumber) {touch(number)}
  action(:touchSave)  {touch(save)}
  action(:touchLogOut) {touch(logOut)}
  
  def ChangeNumber
    touchNumber
    number1 = query(number)[0]["text"]
    number2 = '5053334425'
    if number1 == number2
      query(number, {:setText => '5043215925'})
    else
      query(number, {:setText => number2})
    end
    touchSave
  end
  
  trait(:trait) { number }
end