Feature: UserRegister
  As a new user i want to sign up so that i can use the app.

  Scenario: Trying to create an account with an email address not already taken.
    Given I am on the sign up page
    And I write my name, email address and password and then confirm my password
    When I hit the Register button
    Then the operation is a success, I have created my account and I get sent to the main page

  Scenario: Trying to create an account with an email address already taken.
    Given I am on the sign up page
    And I write my name, email address and password and then confirm my password
    When I hit the Register button
    Then the operation is a failure and a warning appears onscreen to tell me that the email address I wrote already belongs to another account

  Scenario: Trying to create an account and repeating your password correctly
    Given I am on the sign up page
    And I write my name, email address and password
    When I correctly confirm my password and hit the Register button
    Then the operation is a success and I have now created my account

  Scenario: Trying to create an account and repeating your password incorrectly
    Given I am on the sign up page
    And I write my name, email address and password
    When I incorrectly confirm my password and hit the Register button
    Then the operation is a failure and a warning appears onscreen to tell me that my password differs from my confirmed password

  Scenario: Trying to create an account without filling in all the required fields
    Given I am on the sign up page
    When I leave any of the required fields empty and hit the Register button
    Then the operation is a failure and a warning appears onscreen to tell me to fill all the required fields