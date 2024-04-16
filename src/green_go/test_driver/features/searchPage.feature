Feature: Search Page
  As a user I want to be able to search for specifics missions/mission types to be able to more effectively gain points

  Scenario: User writes 'public transport' on the search text input box
    Given that I am in the Search page
    And I wrote the keyword 'public transport' in the search text input box
    When I hit the Enter button in my phone's keyboard
    Then only the missions that have the keyword 'public transport' in their name or in their type will appear onscreen

  Scenario: User writes 'banana' on the search text input box
    Given that I am in the Search page
    And I wrote the keyword 'banana' in the search text input box
    When I hit the Enter button in my phone's keyboard
    Then no missions will be displayed onscreen, only the '0 Search Results' message