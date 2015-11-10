class HelpPage < DroidLeeo
  
  
  element(:done) { "button marked:'Button.back'"}
  
  action(:touchDone) {touch(done)}
  
  trait(:trait) { done }
  
end