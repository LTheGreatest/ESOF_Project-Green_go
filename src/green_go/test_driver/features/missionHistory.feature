Feature: Mission History
  As a user I want to see my mission history so that I know what missions have I been doing and when

  Scenario: User checks his mission history
    Given that I successfully login
    When I go to my Profile Page
    And click on the Mission History button
    Then I expect to see a list of past missions I have completed along with their completion date