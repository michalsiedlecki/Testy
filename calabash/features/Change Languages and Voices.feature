Feature: Change Languages and Voices  
Scenario: I will change voice language using settings in app   
When I press "Login"
    
And I press "Login with Email"
    
And I enter text "michal.siedlecki@blstream.com" into field with id "email"
    
And I enter text "endomondo22" into field with id "password"
    
And I press "Login"

And I press view with contentDescription "More options"
And I press "Audio Settings"
And I press "Languages and Voices"
And I press "Android SpeechSynthesis"
And I press "Italian"
And I press "Test Voice"
And I wait for 5 seconds
And I press "Select Voice"
And I press view with contentDescription "Navigate up"
And I press view with id "ButtonCountdownStopText"

And I wait for 12 seconds