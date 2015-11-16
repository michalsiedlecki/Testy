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