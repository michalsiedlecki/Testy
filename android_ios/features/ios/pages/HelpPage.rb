class HelpPage < DroidLeeo
  
  element(:done) { "button id:'Button.back'"}
  
  def touchDone
    touch(done)
  end
  
  trait(:trait) { done }
  
end