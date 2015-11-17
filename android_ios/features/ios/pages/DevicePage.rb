class DevicePage < DroidLeeo
  element(:menu) { "* marked:'Drawer menu'"}
  element(:humidity) { "Label marked:'Label.humidity-value'"}
  element(:temperature) { "Label marked:'Label.temperature-value'"}
  element(:alert) { "* marked:'High Temperature'"}
  element(:light) { "button marked:'Button.light-settings'"}
  
  #action(:touchMenu) {touch(menu)}
  #action(:touchLight) {touch(light)}
  
  def touchMenu
    touch(menu)
  end
  def touchLight
    touch(light)
  end
  
  trait(:trait) { menu }
  
  def checkTemperature(tempC, tempF)
    wait_for_element_does_not_exist("Label marked:'Label.temperature-value' text:'--'")
    t = query(temperature)[0]["text"]
    if tempC != t && tempF != t
      raise "Temperatures are not equal"
    end
  end
   
  def checkHumidity(humi)
    wait_for_element_does_not_exist("Label marked:'Label.humidity-value' text:'--'")
    h = query(humidity)[0]["text"]
    print humi, " = ", h
    raise "Humiditys are not equal" unless humi == h
  end
   
  def checkAlert(message)
    wait_for_element_exists("* marked:'High Temperature' text:'#{message}'")
    m = query(alert)[0]["text"]
    print message, " = ", m
    raise "Message are not equal" unless message == m   
  end
end