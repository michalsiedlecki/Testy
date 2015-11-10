class MenuPage < DroidLeeo
  
  
  element(:home) { "TextView id:'label'"}
  element(:help) { "TextView id:'help_label'"}
  element(:myAccount) { "TextView id:'account_label'"}
  
  action(:touchMyAccount) {touch(myAccount)}
  action(:touchHome) {touch(home)}
  action(:touchHelp) {touch(help)}
  
  trait(:trait) { myAccount }
end