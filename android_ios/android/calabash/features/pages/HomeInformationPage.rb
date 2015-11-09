class HomeInformationPage < DroidLeeo
  
   
   element(:street) { "EditText id:'home_information_address_line_one'"}
   element(:save) { "Button id:'save_button'"}
  
  action(:touchSave) {touch(save)}
  action(:touchStreet) {touch(street)}
  
  trait(:trait) { street }
  
  def ChangeAddress
    touchStreet
    street1 = query(street)[0]["text"]
    street2 = 'Niepodleglosci'
    if street1 == street2
      query(street, {:setText => 'Krakowska'})
    else
      query(street, {:setText => street2})
    end
    touchSave
  end
  
    
end