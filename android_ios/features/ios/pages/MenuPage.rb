class MenuPage < DroidLeeo
  
  
  element(:home) { "Label marked:'Label.headerInfo-0'"}
  element(:help) { "label marked:'Help'"}
  element(:myAccount) { "label marked:'My Account'"}
  
  action(:touchMyAccount) {touch(myAccount)}
  action(:touchHome) {touch(home)}
  action(:touchHelp) {touch(help)}
  
  trait(:trait) { myAccount }
end