Feature: Missions Details Page
  As a user I want to see the details of a mission so that I know its frequency and how many points I will receive after completing it

  Scenario: User checking a mission's details from the search page
    Given I am on the search page
    When I click on a mission
    Then I expect the mission's details to be displayed in the screen

  Scenario: User checking a mission's details from the main page
    Given I am on the main page
    When I click on a mission
    Then I expect the mission's details to be displayed in the screen