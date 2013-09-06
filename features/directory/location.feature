Feature: Show Location
    As a visitor of the website
    I want to find traders near my location

    Scenario: I find my location
      Given Directory contains my location
      When I open directory index
      Then I should see my location in the list

    Scenario: I find location page
      Given Directory contains my location
      And My location has traders
      When I open location page
      Then I should see location name as header
      And Location name should be in the title
      And I should see a list of traders
