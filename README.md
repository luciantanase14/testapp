# Project Title

Building a Fortified Docker Image for Golang Applications

## Setup of the Go project before running docker build/run commands
Run the following commands in the order:
1) go mod init testapp
2) go mod tidy

### Installation

# Running with a Non-Root User steps need an adjustment to Dockerfile and main.go to work:
1) docker build -t testapp .
2) docker run -d --name my_testapp -p 8080:80 testapp

# Running with a Root User steps to work without adjusting main.go application file:
1) docker build -t testapp .
2) docker run -d --name my_testapp_root --user root -p 8080:80 testapp
