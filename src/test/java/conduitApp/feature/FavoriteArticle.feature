@favorite
@smoke
@parallel=false
Feature: Home Work - Favorite Articles and Comments

    Background: Preconditions
        * url apiURL
        * def config = karate.callSingle('classpath:karate-config.js')
        * def userName = config.userName
        * def isValidTime = read ('classpath:helpers/time-validator.js')

    Scenario: Favorite articles
        # Step 1: Get articles of the global feed
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        Given path 'articles'
        And params {limit: 10, offset:0}
        When method GET
        Then status 200
        * def firstSlugId = response.articles[0].slug
        * def firstFavoritesCount = response.articles[0].favoritesCount

        # Step 3: Make POST request to increase favorites count for the first article
        # Step 4: Verify response schema
        # Step 5: Verify that favorites article incremented by 1
        Given path 'articles', firstSlugId, 'favorite'
        And header Content-Length = 0
        When method POST
        Then status 200
        And match response.article == 
        """
            {
                "id": "#number",
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? isValidTime(_)",
                "updatedAt": "#? isValidTime(_)",
                "authorId": "#number",
                "tagList": "#array",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favoritedBy": "#array",
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
        """
        * def updatedFavoritesCount = response.article.favoritesCount
        And match updatedFavoritesCount == firstFavoritesCount + 1

        # Step 6: Get all favorite articles
        # Step 7: Verify response schema
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        Given params {favorited: '#(userName)', limit: 10, offset: 0}
        And path 'articles'
        When method GET
        Then status 200
        * def articleValidation = read('classpath:conduitApp/validation/articleValidation.json')
        And match each response.articles == articleValidation

        And match response.articlesCount == "#number"
        And match response.articles[*].slug contains ["#(firstSlugId)"]

        # step 9: reset the favorite article
        Given path 'articles', firstSlugId, 'favorite'
        When method DELETE
        Then status 200

    Scenario: Comment articles

        # Prepare the comment request payload
        * def commentRequestBody = read ('classpath:conduitApp/payload/commentRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def commentBody = dataGenerator.getRandomString()
        * set commentRequestBody.comment.body = commentBody

        # Step 1: Get articles of the global feed
        # Step 2: Get the slug ID for the first arice, save it to variable
        Given path 'articles'
        And params {limit: 10, offset:0}
        When method GET
        Then status 200
        * def firstSlugId = response.articles[0].slug

        # Step 3: Make a GET call to 'comments' end-point to get all comments of the firstSlugId
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array lentgh and save to variable
        Given path 'articles', firstSlugId, 'comments'
        When method GET
        Then status 200
        # And match each response.comments == 
        # """
        #     {
        #         "id": "#number",
        #         "createdAt": "#? isValidTime(_)",
        #         "updatedAt": "#? isValidTime(_)",
        #         "body": "#string",
        #         "author": {
        #             "username": "#(userName)",
        #             "bio": "##string",
        #             "image": "#string",
        #             "following": "#boolean"
        #         }
        #     }
        # """
        * def commentCount = response.comments ? response.comments.length : 0

        # Step 6: Make a POST request to publish a new comment
        # Step 7: Verify response schema that should contain posted comment text
        Given path 'articles', firstSlugId, 'comments'
        And request commentRequestBody
        When method POST
        Then status 200
        And match response ==
        """
            {
                "comment": {
                  "id": "#number",
                  "createdAt": "#? isValidTime(_)",
                  "updatedAt": "#? isValidTime(_)",
                  "body": "#(commentBody)",
                  "author": {
                    "username": "#(userName)",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                  }
                }
            }
        """
        * def newCommentId = response.comment.id

        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        Given path 'articles', firstSlugId, 'comments'
        When method GET
        Then status 200
        * def commentCountAdded = response.comments.length
        And match commentCountAdded == commentCount + 1

        # Step 10: Make a DELETE request to delete comment
        Given path 'articles', firstSlugId, 'comments', newCommentId
        When method DELETE
        Then status 200

        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles', firstSlugId, 'comments'
        When method GET
        Then status 200
        * def commentCountDeleted = response.comments.length
        And match commentCountDeleted == commentCountAdded - 1

    Scenario: Prepare a like to an article
        # Like the 2nd article if no likes    
        Given path 'articles'
        And params {limit: 10, offset:0}
        When method GET
        Then status 200
        * def favoritesCount1st = response.articles[0].favoritesCount
        * def article = response.articles[0]

        * if (favoritesCount1st == 0) karate.call('classpath:helpers/AddLikes.feature', article)

        # Reset like
        Given path 'articles', article.slug, 'favorite'
        When method DELETE
        Then status 200

   Scenario: Retry and sleep call
        * def sleep = function(pause){ java.lang.Thread.sleep(pause) }    
        * configure retry = {limit: 3, interval: 2000}
        
        # sleep
        Given path 'articles'
        And params {limit: 10, offset:0}
        When method GET
        * eval sleep(3000)
        Then status 200

        # # retry
        # Given path 'articles'
        # And params {limit: 10, offset:0}
        # And retry until response.articles[0].favoritesCount == 0
        # When method GET
        # Then status 200
    
    @debug
    Scenario:Datatype conversion
        # Number to string
        * def foo = 10
        # convert from number to string: #(foo + '')
        * def json = {"bar": #(foo + '')}
        * match json == {"bar": '10'}

        # string to number
        * def foo1 = '10'
        # way 1: #(foo * 1)
        * def json2 = {"bar" : #(foo * 1)}
        # way 2: #(~~parseInt(foo))
        * def json3 = {"bar" : #(~~parseInt(foo))}
        * match json2 == {"bar" : 10}
        * match json3 == {"bar" : 10}

        