
#Stage1
FROM maven:3.8.5-openjdk-17-slim as build
WORKDIR /app
COPY . .
RUN ./mvnw package -DskipTests


#Stage 2: Runtime stage
FROM openjdk:11-jre-slim AS runtime
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]