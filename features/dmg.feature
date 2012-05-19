Feature: dmg

  In order to install dmgs via the command line
  As a Mac user
  I want to type dmg install chrome and it should just work!

  Scenario: Run dmg for the first time
    When I run `dmg list`
    Then the output should contain "chrome"
    Then the file ".dmg/sources.yml" should contain:
      """
      - https://raw.github.com/pcreux/dmg-pkgs/master/pkgs.yml
      """
