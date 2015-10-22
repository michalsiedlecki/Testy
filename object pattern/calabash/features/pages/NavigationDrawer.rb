class NavigationDrawer < DroidEndomondo
  
  element(:historyButton) { "RobotoTextView text:'History'" }
  
  trait(:trait) { historyButton }
  
  action(:touchHistoryButton) { tap_when_element_exists(historyButton) }
  
end