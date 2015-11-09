class MenuPage < DroidLeeo
  
  
  element(:home) { "label marked:'HOME'"}
  element(:help) { "label marked:'Help'"}
  element(:myAccount) { "label marked:'My Account'"}
  
  action(:touchMyAccount) {touch(myAccount)}
  action(:touchHome) {touch(home)}
  action(:touchHelp) {touch(help)}
  
  trait(:trait) { myAccount }
end