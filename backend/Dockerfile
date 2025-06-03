# Create file: backend/Dockerfile
FROM openjdk:17-jdk-slim as builder

WORKDIR /app
COPY . .
RUN javac Main.java

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/Main.class .
CMD ["java", "Main"]
# Expose port 8080