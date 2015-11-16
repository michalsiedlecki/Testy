class AccountPage < DroidLeeo
  
  element(:logOut) { "button marked:'Button.log-out'"}
  element(:number) { "TextField marked:'TextField.phone-number'"}
  element(:save) { "button marked:'Button.save'"}
  
  def touchNumber
    touch(number)
  end
  
  def touchSave
    touch(save)
  end
  
  def touchLogOut
    touch(logOut)
  end
  
  trait(:trait) { number }
  
  def ChangeNumber(number1, number2)
    touchNumber
    if number1 == query(number)[0]["text"]
      fast_enter_text(number2)
    else
      fast_enter_text(number1)
    end
    touchSave
  end
end