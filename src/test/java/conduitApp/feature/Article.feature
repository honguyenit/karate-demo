@article
@parallel=false
@smoke
Feature: Article Test

    Background:
        # create the article payload request
        * def articleRequestBody = read ('classpath:conduitApp/payload/articleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomArticleValues = dataGenerator.getRandomArticleValues()
        * set articleRequestBody.article.title = randomArticleValues.title
        * set articleRequestBody.article.description = randomArticleValues.description
        * set articleRequestBody.article.body = randomArticleValues.body

        Given url apiURL 
    Scenario: Create articles
        # Create a new article
        And path 'articles'
        And request articleRequestBody
        When method POST
        Then status 201
        And match response.article.title == randomArticleValues.title
        * def articleId = response.article.slug

        # Check the newly created artile is in the article list
        Given params {limit: 10, offset: 0}
        And path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].title == randomArticleValues.title

        # Delete the created article
        And path 'articles',articleId
        When method DELETE
        Then status 204

        # Check the deleted artile is NOT in the article list
        Given params {limit: 10, offset: 0}
        And path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].title != randomArticleValues.title

    Scenario: Create and Delete Article
          # Create a new article
          And path 'articles'
          And request articleRequestBody
          When method POST
          Then status 201
          And match response.article.title == randomArticleValues.title
          * def articleId = response.article.slug
  
          # Delete the created article
          And path 'articles',articleId
          When method DELETE
          Then status 204

        


