# ============================================================
# Lab 6 - Dockerfile for the Java Calculator (multi-stage build)
# Stage 1 : BUILD  - use a full Maven + JDK image to compile & package
# Stage 2 : RUNTIME - use a slim JRE image to run the jar (smaller image)
# ============================================================

# ---- Stage 1: build the executable jar ----
# FROM selects the base image for this stage.
# maven:3.8-openjdk-17 bundles Maven 3.8 and OpenJDK 17, so we can run
# `mvn package` without installing a build tool separately.
FROM maven:3.8-openjdk-17 AS builder

# WORKDIR sets the working directory for this stage; it is created if missing.
WORKDIR /app

# COPY <src> <dst> copies files from the build context into the image.
# Copying pom.xml first (before the source) lets Docker cache dependencies.
COPY pom.xml .

# RUN executes a shell command while the image is being built.
# Resolve/download Maven dependencies ahead of time so they are cached.
RUN mvn dependency:go-offline

# Copy the source tree into the image.
COPY src ./src

# Package the project: compile, run tests, and produce target/calculator.jar.
RUN mvn clean package -DskipTests=false

# ---- Stage 2: minimal runtime image ----
# openjdk:17-jre-slim is much smaller than the Maven image because it
# contains only the JRE (no compiler, no Maven).
FROM openjdk:17-jre-slim

# Declare the port the container listens on (documentational here).
EXPOSE 8080

# Create a non-root user so the container does not run as root (security).
RUN useradd -m -u 1000 appuser
USER appuser

# WORKDIR for the runtime stage.
WORKDIR /app

# COPY --from=builder copies only the built jar from stage 1 into stage 2.
COPY --from=builder /app/target/calculator.jar ./calculator.jar

# ENTRYPOINT defines the process that starts when the container runs.
ENTRYPOINT ["java", "-jar", "calculator.jar"]

# CMD provides default arguments if none are supplied on the command line.
CMD []
