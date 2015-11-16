class MainPage < DroidLeeo
  element(:menu) { "* marked:'Drawer menu'"}
  
  def touchMenu
    touch(menu)
  end
  
  trait(:trait) { menu }
end