class HomeInformationPage < DroidLeeo
  
   
   element(:street) { "TextField marked:'TextField.address-one'"}
   element(:save) { "button marked:'Button.save'"}
  
  action(:touchSave) {touch(save)}
  action(:touchStreet) {touch(street)}
  
  trait(:trait) { street }
  
  def ChangeAddress(street1, street2)
    touchStreet
    touch(street)
    if street1 == query(street)[0]["text"]
      fast_enter_text(street2)
    else
      fast_enter_text(street1)
    end
    touchSave
  end
  
    
end