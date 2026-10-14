# syntax=docker/dockerfile:1

# ---- build ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /workspace
# Optional Maven Central mirror (e.g. in restricted CI networks)
ARG MAVEN_MIRROR_URL=""
RUN if [ -n "$MAVEN_MIRROR_URL" ]; then \
      mkdir -p /root/.m2 && printf '<settings><mirrors><mirror><id>mirror</id><mirrorOf>central</mirrorOf><url>%s</url></mirror></mirrors></settings>' "$MAVEN_MIRROR_URL" > /root/.m2/settings.xml; \
    fi
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2/repository mvn -B -q dependency:go-offline
COPY src ./src
RUN --mount=type=cache,target=/root/.m2/repository mvn -B -q package -DskipTests \
    && java -Djarmode=tools -jar target/pokefolio-backend-*.jar extract --layers --launcher --destination target/extracted

# ---- runtime ----
FROM eclipse-temurin:21-jre-alpine
# busybox wget (used by the healthcheck) ships with alpine
RUN addgroup -S pokefolio && adduser -S pokefolio -G pokefolio
WORKDIR /app
COPY --from=build /workspace/target/extracted/dependencies/ ./
COPY --from=build /workspace/target/extracted/spring-boot-loader/ ./
COPY --from=build /workspace/target/extracted/snapshot-dependencies/ ./
COPY --from=build /workspace/target/extracted/application/ ./
USER pokefolio
EXPOSE 8080
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError" \
    SPRING_PROFILES_ACTIVE=prod
HEALTHCHECK --interval=15s --timeout=3s --start-period=40s --retries=5 \
  CMD wget -qO- http://localhost:8080/actuator/health/readiness | grep -q '"UP"' || exit 1
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
