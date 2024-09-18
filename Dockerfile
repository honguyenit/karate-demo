FROM maven:3.9.8-eclipse-temurin-11

WORKDIR /usr/src/app

COPY pom.xml /usr/src/app

COPY ./src/test/java /usr/src/app/src/test/java 

COPY .env /usr/src/app