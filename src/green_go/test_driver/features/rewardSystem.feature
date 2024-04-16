Feature: Reward System
  As a user I want to receive rewards or badges for completing milestones so that I can feel rewarded for my achievements within the app

  Scenario: User receives a reward/badge
    Given I am successfully logged in
    When I complete a milestone/achievement
    Then I expect to receive the reward or badge associated with my accomplishment

  Scenario: User checks his achievements
    Given I am successfully logged in
    And I am in my Profile page
    When I hit the Achievements button
    Then I expect to go to the Achievements page and see the achievements I have won