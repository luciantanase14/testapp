# Using an Alpine-based Golang image for the building stage:
FROM golang:alpine AS builder

# Install git, required for fetching Go modules:
RUN apk update && apk add --no-cache git

# Setting up the working directory inside the container:
WORKDIR /app

# Copying the local Go source code into the container
COPY main.go .
COPY go.mod .

# Building the Go app which compiles the application for Linux, disables CGO, and statically links all dependencies:
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Starting a new stage from scratch for a secure final image:
FROM alpine:latest

# Add CA certificates for secure communication:
RUN apk --no-cache add ca-certificates openssl

# Creating a non-root user for running the application securely:
RUN adduser -D appuser

# Copy the compiled binary from the builder stage to the current stage:
COPY --from=builder /app/main /usr/local/bin/main

# Set the executable permission for the main binary:
RUN chmod +x /usr/local/bin/main

# Copy the entrypoint script into the image and give it execute permissions:
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to the non-root user:
USER appuser

# Set the working directory in the container:
WORKDIR /home/appuser

# Expose the port the app listens on:
EXPOSE 80

# Using the entrypoint script to start the container, this script will handle SALT generation:
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
