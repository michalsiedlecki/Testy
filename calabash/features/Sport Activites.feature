Feature: Sport Activites feature

  
Scenario: I will change sport activites
    
When I press "Login"
    
And I press "Login with Email"
    
And I enter text "michal.siedlecki@blstream.com" into field with id "email"
    
And I enter text "endomondo22" into field with id "password"
    
And I press "Login"

And I press "Running"
And I press "Hiking"
Then I see "Hiking"