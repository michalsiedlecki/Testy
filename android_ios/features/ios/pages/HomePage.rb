class HomePage < DroidLeeo
  
   element(:homeInformation) { "ResidenceSettingsCell marked: 'Cell.home-information'" }
   element(:celsius) { "label marked:'°C'"}
   element(:fahrenheit) { "label marked:'°F'"}
   element(:back) { "button marked:'Button.back'"}
  
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