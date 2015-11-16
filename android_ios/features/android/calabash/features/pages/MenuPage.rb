class MenuPage < DroidLeeo
  
  element(:device) { "TextView text:'Alarm'"}
  element(:home) { "TextView id:'label'"}
  element(:help) { "TextView id:'help_label'"}
  element(:myAccount) { "TextView id:'account_label'"}
  
  
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