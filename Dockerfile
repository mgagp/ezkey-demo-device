# syntax=docker/dockerfile:1
# Standalone build for Ezkey Demo Device (Maven inside Docker, BuildKit cache for ~/.m2).

FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /build

COPY pom.xml openapi-spec.json ./
COPY src ./src

RUN --mount=type=cache,target=/root/.m2,id=ezkey-demo-device-maven,sharing=locked \
	echo "Building ezkey-demo-device (BuildKit Maven cache)..." && \
	mvn -B -DskipTests clean package

FROM eclipse-temurin:25-jre-alpine AS runtime
RUN apk add --no-cache curl \
	&& addgroup -S spring && adduser -S spring -G spring \
	&& mkdir -p /app/data/enrollments \
	&& chown -R spring:spring /app

WORKDIR /app

COPY --from=build --chown=spring:spring /build/target/*.jar app.jar

USER spring:spring

EXPOSE 8083

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
	CMD curl -fsS http://127.0.0.1:8083/ >/dev/null || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
