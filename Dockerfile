# Using an Alpine-based Golang image for the building stage:
FROM golang:alpine AS builder

# Install git, required for fetching Go modules:
RUN apk update && apk add --no-cache git

# Setting up the working directory inside the container:
WORKDIR /app

# Copying the local Go source code into the container
COPY main.go .

# Building the Go app which compiles the application for Linux, disables CGO, and statically links all dependencies:
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Starting a new stage from scratch for a secure final image:
FROM alpine:latest

# Add CA certificates in case the app needs and makes HTTPS requests:
RUN apk --no-cache add ca-certificates

# Creating a non-root user for running the application securely:
RUN adduser -D appuser

# Copy the compiled binary from the builder stage to the current stage:
COPY --from=builder /app/main .

# Copy entrypoint script and make it executable:
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to the non-root user:
USER appuser

# Set the working directory in the container:
WORKDIR /home/appuser

# Copy the compiled binary from the builder stage to the current stage:
COPY --from=builder /app/main .

# Expose the port the app listens on:
EXPOSE 80

# Using the entrypoint.sh script as the entry point:
ENTRYPOINT ["entrypoint.sh"]

# Command to run the executable:
CMD ["./main"]
