# Project Title

Building a Fortified Docker Image for Golang Applications

## Installation

Running with a Non-Root User steps:
1) docker build -t testapp .
2) docker run -d --name test_app -p 80:80 testapp

Running with a Root User steps:
1) docker build -t root-testapp .
2) docker run -d --name test_app_root --user root -p 80:80 root-testapp
