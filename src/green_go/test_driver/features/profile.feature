Feature: Profile Page
  As a user I want to access my user profile so that I can check my personal information.

  Scenario: User enters the profile page
    Given that I successfully login
    When I hit the Profile button in the menu
    Then I expect to go to my Profile page