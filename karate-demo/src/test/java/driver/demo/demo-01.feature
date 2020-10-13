Feature: browser automation 1

Background:
  * configure driver = { type: 'chrome', showDriverLog: true }
  # * configure driverTarget = { docker: 'justinribeiro/chrome-headless', showDriverLog: true }
  # * configure driverTarget = { docker: 'ptrthomas/karate-chrome', showDriverLog: true }
  # * configure driver = { type: 'chromedriver', showDriverLog: true }
  # * configure driver = { type: 'geckodriver', showDriverLog: true }
  # * configure driver = { type: 'safaridriver', showDriverLog: true }
  # * configure driver = { type: 'iedriver', showDriverLog: true, httpConfig: { readTimeout: 120000 } }
  * url demoBaseUrl

Scenario: try to login to github
    and then do a google search

  Given driver 'https://github.com/login'
  And input('#login_field', 'dummy')
  And input('#password', 'world')
  When submit().click("input[name=commit]")
  Then match html('#js-flash-container') contains 'Incorrect username or password.'

  Given driver 'https://google.com'
  And input("input[name=q]", 'karate dsl')
  When submit().click("input[name=btnI]")
  Then waitForUrl('https://github.com/intuit/karate')

Scenario: pass cookie from API call to UI call
    Given path 'search', 'cookies'
    And cookie foo = {value:'bar', path:'/search'}
    When method get
    Then status 200
    And match response == '#[1]'
    And match response[0] contains { name: 'foo', value: 'bar' }

    Given driver demoBaseUrl + '/search/cookies'
    * print responseCookies
    When setCookies(responseCookies)
    Then match driver.cookies == '#[1]'
