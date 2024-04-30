Feature: User Logout
As a user that has already signed up I want to logout from my account so that I can login with another account.

Scenario: User logs out 
  Given I am signed in
  And that I am in the profile page
  When I press the Logout button
  Then I successfully log out and get sent to the start page