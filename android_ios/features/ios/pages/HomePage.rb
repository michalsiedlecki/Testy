class HomePage < DroidLeeo
  
   element(:homeInformation) { "ResidenceSettingsCell marked: 'Cell.home-information'" }
   element(:celsius) { "RadioButton id:'Button.celsius'"}
   element(:fahrenheit) { "RadioButton id:'Button.fahrenheit'"}
   element(:back) { "button marked:'Button.back'"}
  
  def touchCelsius
     touch(celsius)
  end
  
  def touchFahrenheit
     touch(fahrenheit)
  end
  
  def touchHomeInformation
    touch(homeInformation)
  end
  
  def touchBack
     touch(back)
  end
  
  trait(:trait) { celsius }
  
  def ChangeUnit
    
   if query(celsius, :isSelected)[0] == 1
     touch(fahrenheit)
   else
      touch(celsius) 
   end
    touch(back)
  end
  
    
 
    
        
  
    
end