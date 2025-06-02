# Create file: backend/Dockerfile
FROM maven:3.8.6-openjdk-11-slim as builder

WORKDIR /app
COPY . .
RUN mvn clean package

FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
# Run the application
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# Note: This Dockerfile assumes that the Maven project is set up correctly
