Feature: Score Page
  As a user I want to be able to see my points metrics and set personal goals so that I can challenge myself to achieve specific objectives

  Scenario: User going to the score details page
    Given that I successfully login
    And I am on the main page
    When I click on the plus button on the score section
    Then I expect to go to the Score Details page

  Scenario: User updates his personal goals
    Given that I am on the Score Details page
    When I click on the Update Goals button
    And I input the desired number of points
    And click on the Save Changes button
    Then I expect to be back at the Score Details page and the Personal Goal field to be updated