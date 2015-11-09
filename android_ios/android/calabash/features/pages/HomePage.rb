class HomePage < DroidLeeo
  
   element(:homeInformation) { "TextView id:'home_information_label'"}
   element(:celsius) { "RadioButton id:'celsius_radio_button'"}
   element(:fahrenheit) { "RadioButton id:'fahrenheit_radio_button'"}
  
  action(:touchCelsius) {touch(celsius)}
  action(:touchFahrenheit) {touch(fahrenheit)}
  action(:touchHomeInformation) {touch(homeInformation)}
  
  trait(:trait) { celsius }
  
  def ChangeUnit
    touchCelsius #if element_exists("#{:celsius} isSelected:1") 
    
    sleep(3)
  end
  
    
 
    
        
  
    
end