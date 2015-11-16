class DevicePage < DroidLeeo
  element(:menu) { "TextView id:'menu_button'"}
  element(:humidity) { "TextView id:'humidity_reading'"}
  element(:temperature) { "TextView id:'temperature_reading'"}
  element(:alert) { "TextView id:'device_alert_status_message'"}
  element(:light) { "Button id:'light_control_button'"}
  
  #action(:touchMenu) {touch(menu)}
  #action(:touchLight) {touch(light)}
  
  trait(:trait) { menu }
  
  def touchMenu
    touch(menu)
  end
  def touchLight
    touch(light)
  end
  
  
  def checkTemperature(temp)
    sleep(2)
    t = query(temperature)[0]["text"]
    print temp, " = ", t
    raise "Temperatures are not equal" unless temp == t
  end
   
  def checkHumidity(humi)
    sleep(2)
    h = query(humidity)[0]["text"]
    print humi, " = ", h
    raise "Humiditys are not equal" unless humi == h
  end
   
  def checkAlert(message)
    sleep(2)
    m = query(alert)[0]["text"]
    print message, " = ", m
    raise "Message are not equal" unless message == m   
  end
end