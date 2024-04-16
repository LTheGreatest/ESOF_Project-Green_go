Feature: UserLogin
  As a user that has already registered i want to login in my account.

  Scenario: User logs in with valid email address and password
    Given I am on the login page
    And that I have created an account using an email address and password
    When I write the correct email address and password and hit the Login button
    Then I successfully login and get sent to the main page

  Scenario: User logs in with invalid email address or password
    Given I am on the login page
    And that I have created an account using an email address and password
    When I write the incorrect email address and/or password and hit the Login button
    Then the operation is a failure and a warning appears onscreen
