@mock
Feature: Mock Server Test

    Background:
        * url 'http://localhost:8088'
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomValue = dataGenerator.getRandomArticleValues().title
    Scenario: Books service test
        # Get all books and the book count
        Given path 'books'
        When method GET
        Then status 200
        And match each response == 
        """
            {
                "name": "#string",
                "publishedDate": "#string",
                "ISBN": "#string",
                "id": "#string"
            }
        """
        * def currentBookcount = response.length

        # Add a new book and get the new book id
        * def newBookName = 'Basic Appium Edition ' + randomValue
        Given path 'book'
        And header Content-Type = 'application/json'
        And request 
        """
            {
                "name": "#(newBookName)",
                "publishedDate": "2001-05-28",
                "ISBN": "978-013468599177"
            }
        """
        When method POST
        Then status 200
        * def newBookId = response.id

        # Search the added book by name
        Given path 'book'
        And params {name: '#(newBookName)'}
        When method GET
        Then status 200
        And match response.name == '#(newBookName)'
        And match response.id == newBookId

        # Search the added book by Id
        Given path 'book/' + newBookId
        When method GET
        Then status 200
        And match response.name == '#(newBookName)'

        # Get all books and compare bookcount as newBookcount == currentBookcount + 1
        Given path 'books'
        When method GET
        Then status 200
        * def newBookcount = response.length
        And match newBookcount == currentBookcount + 1

        # Delete the added book
        Given path 'book/' + newBookId
        When method DELETE
        Then status 204

        # Get all books and compare bookcount as deletedBookcount == newBookcount - 1
        Given path 'books'
        When method GET
        Then status 200
        * def deletedBookcount = response.length
        And match deletedBookcount == newBookcount - 1

        # double check to get the deleted book id with status 404 Not Found
        Given path 'book/' + newBookId
        When method GET
        Then status 404
 Scenario: Library service test
    Given path 'lib'
    When method GET
    Then status 200
    And match response ==
    """
        {
            "name": "#string",
            "location": "#string",
            "establishedYear": "#number",
            "totalBooks": "#number",
            "hours": {
                "Monday": "#string",
                "Tuesday": "#string",
                "Wednesday": "#string",
                "Thursday": "#string",
                "Friday": "#string",
                "Saturday": "#string",
                "Sunday": "#string"
            },
            "services": [
                "Book Lending",
                "Reading Rooms",
                "Public Computers",
                "Events and Workshops"
            ]
        }
    """