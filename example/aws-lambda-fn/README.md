# Terraform Docker Artifact Packager - AWS Lambda Example

This is an example of using the Terraform Docker Artifact Package module to
package a TypeScript app into a Docker image, extract the compiled JavaScript
file, and use it as the source code for an AWS Lambda function.

## Prerequisites

- Terraform installed on your local machine
- Docker installed on your local machine
- AWS account with the necessary permissions to create Lambda functions and
  IAM roles
- AWS CLI installed and configured with your AWS account
