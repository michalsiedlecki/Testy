class LightPage < DroidLeeo
  
  element(:picker) { " all ISColorKnob"}
  element(:done) { "button marked:'Button.done'"}
  element(:colors) { "ThreeCirclesView marked:'Button.quick-colors-palette'"}
  
  def touchDone
    touch(done)
  end
  
  
  #action(:touchDone) {touch(done)}
  
  def white(corx = 164, cory = 235)
    x = query(picker, :frame)[0]["X"].round
    y = query(picker, :frame)[0]["Y"].round
    if x != corx || y != cory
        tap_point(corx, cory)
    end
  end
  
  
  trait(:trait) { picker }
  
end