class DevicePage < DroidLeeo
  element(:menu) { "TextView id:'menu_button'"}
  element(:humidity) { "TextView id:'humidity_reading'"}
  element(:temperature) { "TextView id:'temperature_reading'"}
  element(:alert) { "TextView id:'check_detectors_status_message'"}
  element(:light) { "Button id:'light_control_button'"}
  #element(:reading) {"TextView id: 'temperature_reading' text:'--'"}
  
  #action(:touchMenu) {touch(menu)}
  #action(:touchLight) {touch(light)}
  
  trait(:trait) { menu }
  
  def touchMenu
    touch(menu)
  end
  def touchLight
    touch(light)
  end
  
  
  def checkTemperature(tempC, tempF)
    wait_for_element_does_not_exist("TextView id:'temperature_reading' text:'--'")
    puts t = query(temperature)[0]["text"]
    if tempC != t && tempF != t
      raise "Temperatures are not equal"
    end
  end
   
  def checkHumidity(humi)
    wait_for_element_does_not_exist("TextView id:'humidity_reading' text:'--'")
    h = query(humidity)[0]["text"]
    print humi, " = ", h
    raise "Humiditys are not equal" unless humi == h
  end
   
  def checkAlert(message)
    wait_for_element_exists("TextView id:'check_detectors_status_message' text:'#{message}'")
    m = query(alert)[0]["text"]
    print message, " = ", m
    raise "Message are not equal" unless message == m   
  end
end