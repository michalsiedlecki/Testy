class MainPage < DroidLeeo
  element(:menu) { "TextView id:'menu_button'"}
  
  def touchMenu
    touch(menu)
  end
  
  trait(:trait) { menu }
end