Feature: Chalenges 
Scenario: I will create new chalenges   
When I press "Login"
    
And I press "Login with Email"
    
And I enter text "michal.siedlecki@blstream.com" into field with id "email"
    
And I enter text "endomondo22" into field with id "password"
    
And I press "Login"

And I press view with contentDescription "Navigation drawer"
And I wait for 2 seconds
And I press TextView with text "Challenges"
And I press "Create"
And I press "START CHALLENGE"
And I enter text "Exercise" into field with id "challenge_name_input"
And I press "Most Workouts"
And I press "Most Kilometers"
And I press "All Sports"
And I press "Running"
And I press "Done"
And I press "Oct 20, 2015"
And I set the date to "08-11-2015" on DatePicker with id "date_picker"
And I press "Done"
And I press "Nov 20, 2015"
And I set the date to "10-11-2015" on DatePicker with id "date_picker"
And I press "Done"
And I enter text "Exercise" into field with id "challenge_description_input"
And I press "START CHALLENGE"