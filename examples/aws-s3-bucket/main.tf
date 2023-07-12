locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
  }
}

module "artifact_builder" {
  source = "../../"

  docker_build_context   = "${path.module}/fixtures/website"
  docker_build_target    = "package"
  artifact_src_type      = "directory"
  artifact_src_path      = "/opt/app/dist/"
  artifact_dst_directory = "${path.module}/dist"
}

resource "random_string" "website_bucket_random_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "example-tf-docker-artifact-packager-${random_string.website_bucket_random_suffix.result}"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset(module.artifact_builder.artifact_dst_directory, "**/*")

  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = each.value
  source       = "${module.artifact_builder.artifact_dst_directory}/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "binary/octet-stream")
  acl          = "public-read"
}
