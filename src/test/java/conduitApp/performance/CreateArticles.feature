@performance
Feature: Article Test

    Background:
        # create the article payload request
        * def articleRequestBody = read ('classpath:conduitApp/payload/articleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomArticleValues = dataGenerator.getRandomArticleValues()
        * set articleRequestBody.article.title = randomArticleValues.title
        * set articleRequestBody.article.description = randomArticleValues.description
        * set articleRequestBody.article.body = randomArticleValues.body

        * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
        * def pause = karate.get('__gatling.pause', sleep)

        Given url apiURL 
    
    @name=pefTags
    Scenario: Debug performance test
        * print 'Debug performance test'
        Given path 'tags'
        When method GET
        Then status 200
        * pause(5000)

    @name=pefArticle
    Scenario: Create and Delete Article
        
          # Create a new article
          And path 'articles'
          And request articleRequestBody
          And header karate-name = 'POST request - Create new article'
          When method POST
          Then status 201
          And match response.article.title == randomArticleValues.title
          * def articleId = response.article.slug
  
          * pause(5000)
          
          # Delete the created article
          And path 'articles',articleId
          And header karate-name = 'DELETE request - Delete article'
          When method DELETE
          Then status 204

        


