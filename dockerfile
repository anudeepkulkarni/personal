FROM maven:3.6.3-jdk-8 AS mvnbuild
LABEL maintainer "devops@matildacloud.com" description "Matilda DEVOPS"

COPY src /usr/src/app/src

COPY pom.xml /usr/src/app

RUN mvn -f /usr/src/app/pom.xml clean package


# FROM gcr.io/distroless/java:8
FROM openjdk:8-jre-alpine

WORKDIR /


COPY src/main/resources/application-dev.properties /


COPY --from=mvnbuild /usr/src/app/target/dynamic-dashboard-*.jar /dynamic-dashboard.jar

EXPOSE 8085

ENTRYPOINT ["/usr/bin/java", "-jar", "/dynamic-dashboard.jar", "--spring.config.location=/application-dev.properties"]
