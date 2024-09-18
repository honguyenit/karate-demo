package helpers;

import com.github.javafaker.Faker;
import net.minidev.json.JSONObject;

public class DataGenerator {
    
    public static String getRandomUserName(){  // to demonstrate how to call static java method (recommended for helpers/utils)
        Faker faker = new Faker();
        String randomUserName = faker.name().username();
        return randomUserName;
    }

    public static String getRandomEmail(){ // to demonstrate how to call static java method (recommended for helpers/utils)
        Faker faker = new Faker();
        String randomEmail = faker.name().username().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return randomEmail;
    }

    public String getRandomUserNameInstance(){ // to demonstrate how to call java function with initalizing a new object
        Faker faker = new Faker();
        String randomUserName = faker.name().username();
        return randomUserName;
    }

    public String getRandomEmailInstance(){  // to demonstrate how to call java function with initalizing a new object
        Faker faker = new Faker();
        String randomEmail = faker.name().username().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return randomEmail;
    }

    public static JSONObject getRandomArticleValues(){ // to demonstrate how to call static java method (recommended for helpers/utils)
        Faker faker = new Faker();
        String title = faker.gameOfThrones().character();
        String description = faker.gameOfThrones().city();
        String body = faker.gameOfThrones().quote();
        
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);

        return json;
    }

    public static String getRandomString(){  // to demonstrate how to call static java method (recommended for helpers/utils)
        Faker faker = new Faker();
        String randomUserName = faker.gameOfThrones().quote();
        return randomUserName;
    }

    public static void main (String [] args){
        System.out.println("getRandomUserName: " + getRandomUserName());
        System.out.println("getRandomEmail: " + getRandomEmail());

        System.out.println("getRandomArticleValues: " + getRandomArticleValues());

        DataGenerator dataGenerator = new DataGenerator();
        System.out.println("getRandomUserNameInstance: " + dataGenerator.getRandomUserNameInstance());
        System.out.println("getRandomEmailInstance: " + dataGenerator.getRandomEmailInstance());
    }
    
}
