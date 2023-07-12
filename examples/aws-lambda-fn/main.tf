module "packager" {
  source = "../../"

  artifact_src_path    = "/tmp/package.zip"
  docker_build_context = "${path.module}/fixures/echo-app"
  docker_build_target  = "package"
  docker_build_args    = {}
}

resource "aws_lambda_function" "this" {
  function_name = "tf-example-echo-app"

  filename         = module.packager.artifact_dst_path
  source_code_hash = filebase64sha256(module.packager.artifact_dst_path)
  handler          = "index.handler"

  runtime = "nodejs18.x"
  role    = aws_iam_role.this.arn
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
}
