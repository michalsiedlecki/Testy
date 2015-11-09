class HelpPage < DroidLeeo
  
  
  element(:done) { "Button id:'done_button'"}
  
  action(:touchDone) {touch(done)}
  
  trait(:trait) { done }
  
end