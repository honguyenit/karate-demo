@home
@smoke
Feature: Home Page Test

    Background: Define url 
        Given url  apiURL

    Scenario: Get tags
        Given path 'tags'
        When method GET
        Then status 200

        And match response.tags contains ['Zoom', 'GitHub']
        And match response.tags contains any ['Cat', 'Dog', 'Coding']
        And match response.tags !contains 'WebEx'
        And match response.tags == "#array"
        And match each response.tags contains "#string"
        
    Scenario: Get Articles
        
        Given params {limit: 10, offset: 0}
        And path 'articles'
        When method GET
        Then status 200

        And match response.articles == "#[10]"

        And match response == {"articles": "#array", "articlesCount": "#number"}

        And match response.articles[0].createdAt contains '2024'
        # And match response.articles[*].favoritesCount contains 11
        And match each response..favoritesCount == "#number"

        And match response.articles[*].author.bio contains null
        And match response..bio contains null
        # If using ##string, it allows "null" or "string"
        And match each response..bio == "##string"

        And match each response..following == false
        And match each response..following == "#boolean"

        # Schema validation
        * def isValidTime = read('classpath:helpers/time-validator.js')
        * def articleValidation = read('classpath:conduitApp/validation/articleValidation.json')
        And match each response.articles == articleValidation


    

     