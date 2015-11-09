class MainPage < DroidLeeo
  element(:menu) { "label marked:'Drawe menu'"}
  
  action(:touchMenu) {touch(menu)}
  
  trait(:trait) { menu }
end