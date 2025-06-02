# Create file: backend/Dockerfile
FROM openjdk:11-jdk

WORKDIR /app

# Copy the Java file
COPY Main.java /app/

# Compile the Java code
RUN javac Main.java

# Run the application
EXPOSE 8080
CMD ["java", "Main"]
