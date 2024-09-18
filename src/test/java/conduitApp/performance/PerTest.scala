package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._
import conduitApp.performance.createTokens.CreateTokens


class PerTest extends Simulation {

    CreateTokens.createAccessTokens() // create tokens list

  val protocol = karateProtocol(
    "/api/articles/{articleId}" -> Nil // to group DELETE /api/articles/{articleId} in the Gatling test report
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  var csvFeeder = csv("conduitApp/performance/data/articlesdata.csv").circular()
  var tokensFeeder = Iterator.continually(Map("mytoken" -> CreateTokens.getNextToken()))


  val getTags = scenario("Get Tags")
                .exec(karateFeature("classpath:conduitApp/performance/CreateArticles.feature@name=pefTags"))

  val createArticles = scenario("create and delete articles")
                        .exec(karateFeature("classpath:conduitApp/performance/CreateArticles.feature@name=pefArticle"))

  val createArticleWithCSVFeeder = scenario("create and delete articles feeder with csv feeder").feed(csvFeeder)
                                    .exec(karateFeature("classpath:conduitApp/performance/CreateArticlesFeeder.feature@name=csvFeeder"))

  val createArticleWithTokenFeeder = scenario("create and delete articles feeder with tokens feeder").feed(tokensFeeder)
                                    .exec(karateFeature("classpath:conduitApp/performance/CreateArticlesFeeder.feature@name=tokensFeeder"))


  setUp(
    getTags.inject(
    // createArticles.inject(
    // createArticleWithCSVFeeder.inject(
    // createArticleWithTokenFeeder.inject(
            atOnceUsers(1),
            nothingFor(1 seconds),
            constantUsersPerSec(1).during(3 seconds)
            // constantUsersPerSec(2).during(10 seconds),
            // rampUsersPerSec(2).to(10).during(10 seconds),
            // nothingFor(5 seconds),
            // constantUsersPerSec(1).during(10 seconds),
        ).protocols(protocol),

    // getTags.inject(
    //     atOnceUsers(2),
    //     ).protocols(protocol)
  )

}