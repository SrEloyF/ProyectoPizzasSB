FROM maven:3.9.1-amazoncorretto-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/target/proyecto-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
