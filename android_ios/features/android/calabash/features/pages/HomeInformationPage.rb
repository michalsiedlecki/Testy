class HomeInformationPage < DroidLeeo
  
   
   element(:street) { "EditText id:'home_information_address_line_one'"}
   element(:save) { "Button id:'save_button'"}
  
  
  def touchSave
   touch(save)
  end
  
  def touchStreet
   touch(street)
  end   
  
  trait(:trait) { street }
  
  def ChangeAddress(street1, street2)
    touchStreet
    if street1 == query(street)[0]["text"]
      query(street, {:setText => street2})
    else
      query(street, {:setText => street1})
    end
    touchSave
  end
  
    
end