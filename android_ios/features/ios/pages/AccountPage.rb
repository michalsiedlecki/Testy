class AccountPage < DroidLeeo
  
  element(:logOut) { "button marked:'Button.log-out'"}
  element(:number) { "TextField marked:'TextField.phone-number'"}
  element(:save) { "button marked:'Button.save'"}
  
  action(:touchNumber) {touch(number)}
  action(:touchSave)  {touch(save)}
  action(:touchLogOut) {touch(logOut)}
  
  def ChangeNumber(number1, number2)
    touchNumber
    if number1 == query(number)[0]["text"]
      fast_enter_text(number2)
    else
      fast_enter_text(number1)
    end
    touchSave
  end
  
  trait(:trait) { number }
end