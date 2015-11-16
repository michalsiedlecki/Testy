class MenuPage < DroidLeeo
  
  element(:device) { "label marked:'Alarm'"}
  element(:home) { "Label marked:'Label.headerInfo-0'"}
  element(:help) { "label marked:'Help'"}
  element(:myAccount) { "label marked:'My Account'"}
  
  def touchMyAccount
    touch(myAccount)
  end
  
  def touchHome
    touch(home)
  end
  
  def touchHelp
    touch(help)
  end
  
  def touchDevice
    touch(device)
  end
  
  
  trait(:trait) { myAccount }
end