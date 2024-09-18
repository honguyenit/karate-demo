# Project guideline

## Precondition
- Java 8+
- Maven

## Run test
If you want to run test on you local machine, please follow the below steps.

### Run all tests
```bash
mvn test
```

- The default env is dev env.
- Can run parallel with `mvn test`. 
- By default, all tests under `classpath:conduitApp/feature` will be run. That is configured under `ConduitTest.java`
- The thread count is configured in `conduitApp/ConduitTest.java`.


### Run all tests with `@smoke` tag in `dev` env

```bash
mvn test -Dkarate.options="--tags @smoke" -Dkarate.env="dev"
```

### Run all tests with `@smoke` tag in `qa` env

```bash
mvn test -Dkarate.options="--tags @smoke" -Dkarate.env="qa"
```

### Run all tests except for tests with `@Ingore` tag

```bash
mvn test -Dkarate.options="--tags ~@ignore"
```
The default env is dev env.

## Run test with docker
If you want to run Karate test from docker container, please follow the below steps.

### Precondition
- Start Docker Desktop (Login may need)
- Make sure docker is available 
    ```bash 
    docker --version
    ```

### Run test
Test on `dev` env:
```bash
KARATE_ENV=dev docker-compose up --build
```

Test on `qa` env:
```bash
KARATE_ENV=qa docker-compose up --build
```

### Stop the service and remove the container
```bash
docker-compose down
```

## Run Performance Test with Gatling

```bash
mvn clean test-compile gatling:test
```

## CI run with GithubAction

### Create Github secret
```
API_URL=your-api-url
DEV_USERNAME=your-dev-username
DEV_USEREMAIL=your-dev-email@example.com
DEV_USERPASSWORD=your-dev-password
QA_USERNAME=your-qa-username
QA_USEREMAIL=your-qa-email@example.com
QA_USERPASSWORD=your-qa-password
```

If we want to run CI with docker (optional), please add the docker credentials to the Github secret
```
DOCKER_USERNAME=your-docker-username
DOCKER_PASSWORD=your-docker-password
```

### Run Action workflow tests with No Docker
- Action name: `Karate Tests`
- File name: `ci-config.yml`

### Run Action workflow tests with Docker
- Action name: `Karate Tests using Docker File & Compose`
- File name: `ci-config-docker.yml`

## Implement mock server with karate
Sometimes, we need to use Mock servers to simulate interactions with external systems that are part of the end-to-end workflow.
### Command to start mock server locally
```bash
mvn test-compile exec:java -Dexec.mainClass=conduitApp.SimpleMockRunner -Dexec.classpathScope=test
```
### Test mock server locally
By default, the mock server is started on the `localhost` and port `8088`. 
#### Command to run mock server test locally
```bash
mvn test -Dkarate.options="--tags @mock"
```
#### Manually play around with mock server
After starting mock server with the command above, we can play around with mock server using POSTMAN
- GET: http://localhost:{port}/lib
- GET:http://localhost:{port}/books
- GET:http://localhost:{port}/book?name=Java
- GET:http://localhost:{port}/book/{id}
- POST (add a new book): http://localhost:{port}/book
Sample request body:
```bash
{
"name": "Advanced Karate",
"publishedDate": "2001-05-28",
"ISBN": "978-013468599177"
}
```
- DELETE: http://localhost:{port}/book/{id}
Besides, we can simply open the brower and enter the urls to play with the mock APIs.
- http://localhost:8088/lib
- http://localhost:8088/books
- http://localhost:8088/book?name=Java
- http://localhost:8088/book/00000000-0000-0000-0000-000000000001
### Run Karate Mock Server Test on CI
If you want to run karate tests with mock server, run job `Karate Mock Server Tests` from `ci-config-mock.yml`.
