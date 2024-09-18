@performance
Feature: Article Test With CSV Feeder

    Background:
        # create the article payload request
        * def articleRequestBody = read ('classpath:conduitApp/payload/articleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomArticleValues = dataGenerator.getRandomArticleValues()
        * set articleRequestBody.article.title = randomArticleValues.title

        * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
        * def pause = karate.get('__gatling.pause', sleep)

        Given url apiURL 

    @name=csvFeeder
    Scenario: Create and Delete Article With CSV Feeder
        
          # Create a new article
          * set articleRequestBody.article.description = __gatling.Description
          * set articleRequestBody.article.body = __gatling.Body
          And path 'articles'
          And request articleRequestBody
          When method POST
          Then status 201
          And match response.article.title == randomArticleValues.title
          * def articleId = response.article.slug
  
          * pause(5000)
          
          # Delete the created article
          And path 'articles',articleId
          When method DELETE
          Then status 204
    
        @name=tokensFeeder
        Scenario: Create and Delete Article With Tokens Feeder
            
              # Create a new article
              * configure headers = {"Authorization": #('Token ' + __gatling.mytoken)}
            #   Given header Authorization = 'Token ' + __gatling.mytoken
              And path 'articles'
              And request articleRequestBody
              When method POST
              Then status 201
              And match response.article.title == randomArticleValues.title
              * def articleId = response.article.slug
      
              * pause(5000)
              
              # Delete the created article
              And path 'articles',articleId
              When method DELETE
              Then status 204

        


