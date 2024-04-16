Feature: Main Page
  As a user I want to have a main page so that I can check out my score, streak and how many more points I need to complete my current goal as well as a few missions that are available to be completed

  Scenario: User checks his score after gaining points
    Given that I am not on the main page
    And I have recently received 10 points
    When I go to the main page
    Then my streak and score should have increased by 10 and the points needed to complete my goal should have decreased by 10

  Scenario: User checks his streak after breaking it
    Given that I am not on the main page
    And my streak has been broken
    When I go to the main page
    Then my streak should have been reset back to 0

  Scenario: User changes his goal
    Given that I am not on the main page
    And I update my goal
    When I go to the main page
    Then my goal should have been updated as well as the points needed to complete it

  Scenario: User has completed a mission
    Given that I am not on the main page
    And I have completed a mission that was listed in it
    When I go to the main page
    Then that mission should not appear anymore until it is reset