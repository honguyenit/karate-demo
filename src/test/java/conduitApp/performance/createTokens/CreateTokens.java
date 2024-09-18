package conduitApp.performance.createTokens;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import com.intuit.karate.Runner;

public class CreateTokens {
    private static final ArrayList <String> tokens = new ArrayList<>();
    private static final AtomicInteger counter = new AtomicInteger();

    private static String[] emails = {
        "karate-test-acc@gmail.com",
        "karate-acc@gmail.com",
        "karate-dev-acc@gmail.com"
    };

    public static String getNextToken(){
        return tokens.get(counter.getAndIncrement() % tokens.size());
    }

    public static void createAccessTokens(){
        for (String email: emails){
            Map <String, Object> accounts = new HashMap<>();
            accounts.put("userEmail", email);
            accounts.put("userPassword", "karate-test");

            Map<String, Object> result = Runner.runFeature("classpath:helpers/CreateToken.feature", accounts, true);
            tokens.add(result.get("authToken").toString());
        }
    }
    
}
