Feature: Leaderboard Page
  As a user I want to check the leaderboard so that i can see my current position in it along with the points of other users

  Scenario: User checks the weekly leaderboard
    Given that I hit the Leaderboard button in the menu
    When I hit the Weekly button in the Leaderboard page
    Then the weekly leaderboard should be displayed, with the amount of points users have gained in the last week

  Scenario: User checks the monthly leaderboard
    Given that I hit the Leaderboard button in the menu
    When I hit the Monthly button in the Leaderboard page
    Then the monthly leaderboard should be displayed, with the amount of points users have gained in the last month

  Scenario: User checks the all time leaderboard
    Given that I hit the Leaderboard button in the menu
    When I hit the All Time button in the Leaderboard page
    Then the all time leaderboard should be displayed, with the total amount of points users have ever gained