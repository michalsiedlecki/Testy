require 'calabash-android/calabash_steps'

Then /^I press view with contentDescription "([^\"]*)"$/ do |contentDescription|
  
tap_when_element_exists("* contentDescription:'#{contentDescription}'")

end



Given /^I set the date to "(.*?)" on DatePicker with id "([^\"]*)"$/ do |date, id|
  set_date("DatePicker id:'#{id}'", date)
end

Given /^I press TextView with text "([^\"]*)"$/ do |text|
  tap_when_element_exists("RobotoTextView text:'#{text}'")
end