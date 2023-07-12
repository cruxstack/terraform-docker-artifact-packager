# Terraform Module Example

## AWS S3 Bucket

This example demonstrates how to use the Artifact Builder Terraform module to
build and deploy a simple static website to AWS S3.

In this example, we have a simple static website composed of HTML files. We use
the Artifact Builder module with `artifact_src_type` set to "directory" to
package the entire website directory as the artifact. This artifact is then
deployed to an AWS S3 bucket, which is configured to host a static website.

This example is intended to show the flexibility of the Artifact Builder module
in handling different artifact types, including whole directories. It also shows
how to integrate the module with other Terraform resources to create a complete
deployment workflow.

### Prerequisites

- Terraform installed on your local machine
- Docker installed on your local machine
- AWS account with the necessary permissions to create Lambda functions and
  IAM roles
- AWS CLI installed and configured with your AWS account
