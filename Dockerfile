# Using an Alpine-based Golang image for the building stage:
FROM golang:alpine AS builder

# Installing git to fetch Go packages
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

# Switch to the non-root user:
USER appuser

# Set the working directory in the container:
WORKDIR /home/appuser

# Copy the compiled binary from the builder stage to the current stage:
COPY --from=builder /app/main .

# Expose the port the app listens on:
EXPOSE 80

# Command to run the executable:
CMD ["./main"]
