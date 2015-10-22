require 'calabash-android/calabash_steps'

Then /^I press view with contentDescription "([^\"]*)"$/ do |contentDescription| 
  tap_when_element_exists("* contentDescription:'#{contentDescription}'")
end

Given /^I set the date to "(.*?)" on DatePicker with id "([^\"]*)"$/ do |date, id|
  set_date("DatePicker id:'#{id}'", date)
end

Given /^I set the time to "(.*?)" on TimePicker with id "([^\"]*)"$/ do |time, id|
  set_time("TimePicker id:'#{id}'", time)
end

Given /^I press TextView with text "([^\"]*)"$/ do |text|
  tap_when_element_exists("RobotoTextView text:'#{text}'")
end

Given /^I set the hour to "(\d+)", minutes to "(\d+)", secunds to "(\d+)" on NumberPicker$/ do |hour, minutes, secunds|
  query("NumberPicker id:'HoursPicker'", setValue:hour.to_i)
  query("NumberPicker id:'HoursPicker'", setValue:hour.to_i)
  query("NumberPicker id:'MinutesPicker'", setValue:minutes.to_i)
  query("NumberPicker id:'SecondsPicker'", setValue:secunds.to_i)
end

Given /^I set distance "(\d+)" km and "(\d+)" m on NumberPicker$/ do |km, m|
  query("NumberPicker id:'MajorPicker'", setValue:km.to_i)
  query("NumberPicker id:'MajorPicker'", setValue:km.to_i)
  query("NumberPicker id:'MinorPicker'", setValue:m.to_i)
end