@signup
@smoke
Feature: Sign up new users

    Background:
        Given url apiURL
    
    Scenario: Sign up
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomUserName = dataGenerator.getRandomUserName()
        * def randomEmail = dataGenerator.getRandomEmail()

        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": "#(randomEmail)",
                    "password": "12345678",
                    "username": "#(randomUserName)"
                }
            }
        """
        When method POST
        Then status 201
        And match response == 
        """
            {
                "user": {
                    "id": "#number",
                    "email": "#(randomEmail)",
                    "username": "#(randomUserName)",
                    "bio": null,
                    "image": "#string",
                    "token": "#string"
                }
            }
        """
    
    Scenario: Sign up with Java instance
    * def jsFunctionGetUserName = 
    """
        function () {
            var DataGenerator = Java.type('helpers.DataGenerator')
            var generate = new DataGenerator()
            return generate.getRandomUserNameInstance()
        }
    """

    * def jsFunctionGetEmail = 
    """
        function () {
            var DataGenerator = Java.type('helpers.DataGenerator')
            var generate = new DataGenerator()
            return generate.getRandomEmailInstance()
        }
    """

    * def randomUserNameInstance = call jsFunctionGetUserName
    * def randomEmailInstance = call jsFunctionGetEmail


    Given path 'users'
    And request
    """
        {
            "user": {
                "email": "#(randomEmailInstance)",
                "password": "123456789",
                "username": "#(randomUserNameInstance)"
            }
        }
    """
    When method POST
    Then status 201
    And match response == 
    """
        {
            "user": {
                "id": "#number",
                "email": "#(randomEmailInstance)",
                "username": "#(randomUserNameInstance)",
                "bio": null,
                "image": "#string",
                "token": "#string"
            }
        }
    """
    
    Scenario Outline: Sign up Errors
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomUserName = dataGenerator.getRandomUserName()
        * def randomEmail = dataGenerator.getRandomEmail()

        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<userName>"
                }
            }
        """
        When method POST
        Then status 422
        And match response == <errorRespone>
    Examples:
    | email                     | userName              | password      | errorRespone                                        |
    | username11233@gmail.com   | #(randomUserName)     | 12345678      | {"errors":{"email":["has already been taken"]}}     |
    | #(randomEmail)            | username112332        | 12345678      | {"errors":{"username":["has already been taken"]}}  |
    |                           | #(randomUserName)     | 12345678      | {"errors":{"email":["can't be blank"]}}             |
    | #(randomEmail)            |                       | 12345678      | {"errors":{"username":["can't be blank"]}}          |
    | #(randomEmail)            | #(randomUserName)     |               | {"errors":{"password":["can't be blank"]}}          |