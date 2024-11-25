# Usa una imagen base con Maven y OpenJDK 21 para construir el proyecto
FROM maven:3.9.1-openjdk-21 AS build

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo pom.xml y las dependencias (esto permite aprovechar la caché de Docker)
COPY pom.xml .

# Descarga las dependencias (esto optimiza la construcción, solo se descarga si cambian las dependencias)
RUN mvn dependency:go-offline

# Copia el código fuente
COPY src ./src

# Construye el archivo JAR
RUN mvn clean package -DskipTests

# Ahora, usa una imagen con OpenJDK para la aplicación final
FROM openjdk:21-jdk-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo JAR desde la etapa de construcción
COPY --from=build /app/target/proyecto-0.0.1-SNAPSHOT.jar app.jar

# Expón el puerto 8080
EXPOSE 8080

# Ejecuta la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
