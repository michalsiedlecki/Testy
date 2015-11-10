class HomePage < DroidLeeo
  
   element(:homeInformation) { "TextView id:'home_information_label'"}
   element(:celsius) { "RadioButton id:'celsius_radio_button'"}
   element(:fahrenheit) { "RadioButton id:'fahrenheit_radio_button'"}
   element(:back) { "RelativeLayout id:'cancel_down_arrow_container'"}
  
  action(:touchCelsius) {touch(celsius)}
  action(:touchFahrenheit) {touch(fahrenheit)}
  action(:touchHomeInformation) {touch(homeInformation)}
  action(:touchBack) {touch(back)}
  
  trait(:trait) { celsius }
  
  def ChangeUnit
    touchCelsius #if element_exists("#{:celsius} isSelected:1") 
    touch(back)
    
  end
  
    
 
    
        
  
    
end