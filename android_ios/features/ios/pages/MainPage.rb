class MainPage < DroidLeeo
  element(:menu) { "* marked:'Drawer menu'"}
  
  action(:touchMenu) {touch(menu)}
  
  trait(:trait) { menu }
end