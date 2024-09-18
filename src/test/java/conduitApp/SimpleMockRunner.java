package conduitApp;

import com.intuit.karate.core.MockServer;

public class SimpleMockRunner {
    public static void main(String[] args) {
        MockServer server = MockServer.featurePaths("classpath:conduitApp/mock/MockServerBooks.feature","classpath:conduitApp/mock/MockServerLibrary.feature")
                .pathPrefix("/")
                .http(8088)
                .watch(true)
                .build();
        server.waitSync();
    }
}
