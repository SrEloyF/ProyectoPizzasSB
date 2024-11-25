# Usa una imagen con OpenJDK 21 y Maven
FROM openjdk:21-jdk-slim AS build

# Instala Maven en la imagen de OpenJDK 21
RUN apt-get update && apt-get install -y maven

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

# Usa una imagen ligera de OpenJDK 21 para la ejecución de la app
FROM openjdk:21-jdk-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo JAR desde la etapa de construcción
COPY --from=build /app/target/proyecto-0.0.1-SNAPSHOT.jar app.jar

# Expón el puerto 8080
EXPOSE 8080

# Ejecuta la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
