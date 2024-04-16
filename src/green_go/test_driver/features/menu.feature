Feature: Menu
  Displays 5 icons that each lead to different pages on the app.

  Scenario: User trying to go to the leaderboard page
  Given I am logged in
  When I click on the “leaderboard button” in the menu
  Then I expect to go to the leaderboard page

  Scenario: User trying to go to the main page
  Given I am logged in
  When I click on the “main page button” in the menu
  Then I expect to go to the main page

  Scenario: User trying to go to the profile page
  Given I am logged in
  When I click on the “profile button” in the menu
  Then I expect to go to the profile page

  Scenario: User trying to go to the trip page
  Given I am logged in
  When I click on the “bus button” in the menu
  Then I expect to go to the trip page

  Scenario: User trying to go to the search mission page
  Given I am logged in
  When I click on the “search button” in the menu
  Then I expect to go to the search page