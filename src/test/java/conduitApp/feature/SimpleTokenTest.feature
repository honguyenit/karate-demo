@tokentest
Feature: Test Simple token Karate (not default)
This is to keep the code of calling CreateToken.feature to get token when needed instead of using the default token for all requests in karate-config.

Background:
    Given url apiURL
    * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature') {"userEmail": "karate-test-acc@gmail.com","userPassword": "karate-test" }
    * def token = tokenResponse.authToken


Scenario: Create articles
    * def newArticleTitle = 'New Article'
    # Create a new article
    Given header Authorization = 'Token ' + token
    And path 'articles'
    And request 
    """
        {
            "article": {
              "title": "#(newArticleTitle)",
              "description": "Article Summary",
              "body": "Article Content",
              "tagList": [
                "GitHub"
              ]
            }
          }
    """
    When method POST
    Then status 201
    And match response.article.title == newArticleTitle
    * def articleId = response.article.slug


    # Delete the created article
    Given header Authorization = 'Token ' + token
    And path 'articles',articleId
    When method DELETE
    Then status 204

