class HelpPage < DroidLeeo
  
  element(:done) { "Button id:'done_button'"}
  
  def touchDone
    touch(done)
  end
  
  trait(:trait) { done }
  
end