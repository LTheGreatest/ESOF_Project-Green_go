Feature: Update Profile
  As a user I want to update my profile's information so that it is up to date and more relevant.

  Scenario: User hits the Edit Profile button
    Given that I successfully login
    When I am in the Profile page
    And hit the Edit Profile button
    Then I expect to be able to edit my profile's information
