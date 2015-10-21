Feature: MainActivity
Scenario: I change some options and run training      
When I press "Login"
And I press "Login with Email"
And I enter text "michal.siedlecki@blstream.com" into field with id "email"
And I enter text "endomondo22" into field with id "password"
And I press "Login"
And I press "Running"
And I press "Hiking"
And I press "Distance"
And I press "Heart Rate"
And I press "Speed"
And I press "Calories"
And I press view with id "ButtonStartPauseFront"



