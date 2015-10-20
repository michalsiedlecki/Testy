Feature: Change birth date  
Scenario: I will change date of birth in profile's settings    
When I press "Login"
    
And I press "Login with Email"
    
And I enter text "michal.siedlecki@blstream.com" into field with id "email"
    
And I enter text "endomondo22" into field with id "password"
    
And I press "Login"

And I press view with contentDescription "More options"
And I press "Settings"
And I press "Profile"
And I press "Date of Birth"
And I set the date to "01-01-2001" on DatePicker with id "DatePicker"
And I wait for 5 seconds
And I press "Ok"