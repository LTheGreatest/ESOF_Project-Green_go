Feature: TransportTripPage
  The page should be the Sustainable Transport Trip Page when clicking on the bus button.

  Scenario: Success
    Given that I successfully login
    When I click on the “bus” button
    Then I expect the “main page” text to be absent and I am on the “sustainable transports page”

  Scenario: Failure
    Given that I successfully login
    When I click on the “bus” button
    Then I expect the “main page” text to be present and an error message to be displayed