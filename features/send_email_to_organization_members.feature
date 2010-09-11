Feature: send emails to organization members
  As a organization administrator
  I want to send email to all members

  Background:
    Given the following users
      | login | name |
      | joaosilva | Joao Silva |
    And the following communities
      | identifier | name |
      | sample-community | Sample Community |
    And "Joao Silva" is admin of "Sample Community"

  Scenario: Cant access if not logged in
    Given I am not logged in
    When I go to /myprofile/sample-community/profile_members/send_mail
    Then I should be on login page

  Scenario: Cant access as normal user
    Given the following user
      | login |
      | josesilva |
    And I am logged in as "josesilva"
    When I go to /myprofile/sample-community/profile_members/send_mail
    Then I should see "Access denied"

  Scenario: Send e-mail to members
    Given I am logged in as "joaosilva"
    And I go to Sample Community's members management
    And I follow "Send e-mail to members"
    And I fill in "Subject" with "Hello, member!"
    And I fill in "body" with "We have some news"
    When I press "Send"
    Then I should be on Sample Community's members management

  Scenario: Not send e-mail to members if subject is blank
    Given I am logged in as "joaosilva"
    And I go to Sample Community's members management
    And I follow "Send e-mail to members"
    And I fill in "body" with "We have some news"
    When I press "Send"
    Then I should be on /myprofile/sample-community/profile_members/send_mail

  Scenario: Not send e-mail to members if body is blank
    Given I am logged in as "joaosilva"
    And I go to Sample Community's members management
    And I follow "Send e-mail to members"
    And I fill in "Subject" with "Hello, user!"
    When I press "Send"
    Then I should be on /myprofile/sample-community/profile_members/send_mail

  Scenario: Cancel creation of mailing
    Given I am logged in as "joaosilva"
    And I go to Sample Community's members management
    And I follow "Send e-mail to members"
    When I follow "Cancel e-mail"
    Then I should be on Sample Community's members management