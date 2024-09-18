Feature: Add Likes

    Background: 
        * url apiURL

Scenario: Add a like
    Given path 'articles', slug, 'favorite'
    And header Content-Length = 0
    When method POST
    Then status 200

    * def likesCount = response.article.favoritesCount
    
