class HomePage < DroidLeeo
  
   element(:homeInformation) { "TextView id:'home_information_label'"}
   element(:celsius) { "RadioButton id:'celsius_radio_button'"}
   element(:fahrenheit) { "RadioButton id:'fahrenheit_radio_button'"}
   element(:back) { "RelativeLayout id:'cancel_down_arrow_container'"}
  
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