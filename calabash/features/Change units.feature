Feature: Change units feature

  
Scenario: I will change units (kilometers/miles) in profile settings    
When I press "Login"
    
And I press "Login with Email"
    
And I enter text "michal.siedlecki@blstream.com" into field with id "email"
    
And I enter text "endomondo22" into field with id "password"
    
And I press "Login"

And I press view with contentDescription "More options"
And I press "Settings"
And I press "Profile"
And I scroll down
And I press "Kilometers"
And I press "Save"
