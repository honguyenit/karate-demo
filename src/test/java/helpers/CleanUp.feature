Feature: Clean up sample

Scenario: Clean up test data
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def message = dataGenerator.getRandomString()
    * print 'Clean up test data: ', message
