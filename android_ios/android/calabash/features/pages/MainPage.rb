class MainPage < DroidLeeo
  element(:menu) { "TextView id:'menu_button'"}
  
  action(:touchMenu) {touch(menu)}
  
  trait(:trait) { menu }
end