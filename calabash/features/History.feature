Feature: History
Scenario: I will add training to history      
When I press "Login"   
And I press "Login with Email"  
And I enter text "michal.siedlecki@blstream.com" into field with id "email"   
And I enter text "endomondo22" into field with id "password"  
And I press "Login"
And I press view with contentDescription "Navigation drawer"
And I press TextView with text "History"
And I press view with id "create_workout_fab"
And I press "Sport"
And I press "Hiking"
And I press "Start time"
And I set the date to "08-11-2015" on DatePicker with id "date_picker"
And I press "Done"
And I set the time to "10:00" on TimePicker with id "time_picker"
And I press "Done"
And I press TextView with text "Duration"
And I set the hour to "5", minutes to "4", secunds to "3" on NumberPicker
And I press "Done"
And I press TextView with text "Distance"
And I set distance from "2" to "3" on NumberPicker
And I press "Done"
And I press "Save"




