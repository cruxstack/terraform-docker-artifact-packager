locals {
  tags = { tf-module = "cruxstack/yopass/aws", tf-module-example = "complete" }
}

module "artifact_packager" {
  source = "../../"

  artifact_dst_directory = "${path.module}/dist"
  artifact_src_path      = "/tmp/package.zip"
  docker_build_context   = "${path.module}/fixtures/echo-app"
  docker_build_target    = "package"
}

resource "aws_lambda_function" "this" {
  function_name    = "tfexample-complete-echo-app"
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = module.artifact_packager.artifact_package_path
  source_code_hash = filebase64sha256(module.artifact_packager.artifact_package_path)
  role             = aws_iam_role.this.arn

  tags = local.tags

  depends_on = [
    module.artifact_packager,
  ]
}

resource "aws_iam_role" "this" {
  name = "tf-example-echo-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = local.tags
}
