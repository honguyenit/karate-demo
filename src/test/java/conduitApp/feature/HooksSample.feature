@hook
@smoke
Feature: Hooks Sample

    Background:
        * print "Before each scenario"
        * configure afterScenario =
        """
            function(){
                var info = karate.info; 
                karate.log('after', info.scenarioName);
            }
        """
        * configure afterFeature = function(){karate.call ('classpath:helpers/CleanUp.feature')}

    Scenario: First Scenario
        * print 'This is the 1st scenario'

    Scenario: Second Scenario
        * print 'This is the 2nd scenario'