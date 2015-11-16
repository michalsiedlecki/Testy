class LightPage < DroidLeeo
  
  element(:picker) { "View id:'color_picker_shadow'"}
  element(:done) { "Button id:'done_button'"}
  element(:colors) { "ImageButton id:'colors_button'"}
  
  
  
  #action(:touchDone) {touch(done)}
  
  def touchDone
    touch(done)
  end
  
  def white(corx = 541, cory = 807)
    x = query(picker)[0]["rect"]["center_x"]
    y = query(picker)[0]["rect"]["center_y"]
    if x != corx || y != cory
        perform_action('touch_coordinate', corx, cory)
    end
    
   
   
  end
  
  
  trait(:trait) { picker }
  
end