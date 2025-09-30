import {
  to = aws_lambda_function.this
  id = "manually-created-lambda"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.root}/build/index.mjs"
  output_path = "${path.root}/lambda.zip"
}


resource "aws_lambda_function" "this" {

  description   = "A starter AWS Lambda function."
  filename      = data.archive_file.lambda_code.output_path
  function_name = "manually-created-lambda"
  handler       = "index.handler"

  kms_key_arn = null
  layers      = []


  replace_security_groups_on_destroy = null
  replacement_security_group_ids     = null
  reserved_concurrent_executions     = -1
  role                               = aws_iam_role.lamda_execution_role.arn
  runtime                            = "nodejs22.x"

  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  tags = {
    "lambda-console:blueprint" = "hello-world"
  }
  tags_all = {
    "lambda-console:blueprint" = "hello-world"
  }
  timeout = 3
  environment {
    variables = {}
  }
  ephemeral_storage {
    size = 512
  }
  logging_config {

    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda.name

  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}