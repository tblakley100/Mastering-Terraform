import {
  to = aws_iam_role.lamda_execution_role
  id = "manually-created-lambda-role-qhh5ase2"
}


import {
  to = aws_iam_policy.lambda_execution
  id = "arn:aws:iam::992382738600:policy/service-role/AWSLambdaBasicExecutionRole-ea8fc800-e56f-4f62-9750-240452fe5329"
}


resource "aws_iam_policy" "lambda_execution" {
  description = null
  name        = "AWSLambdaBasicExecutionRole-ea8fc800-e56f-4f62-9750-240452fe5329"
  name_prefix = null
  path        = "/service-role/"
  policy = jsonencode({
    Statement = [{
      Action   = "logs:CreateLogGroup"
      Effect   = "Allow"
      Resource = "arn:aws:logs:us-east-2:992382738600:*"
      }, {
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
    }]
    Version = "2012-10-17"
  })
  tags     = {}
  tags_all = {}
}



resource "aws_iam_role" "lamda_execution_role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  description           = null
  force_detach_policies = false

  name        = "manually-created-lambda-role-qhh5ase2"
  name_prefix = null
  path        = "/service-role/"

}