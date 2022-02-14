data "archive_file" "lambda_zip" {
  type             = "zip"
  source_dir       = "${path.module}/lambda"
  output_path      = "${path.module}/lambda.zip"
  output_file_mode = "0666"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.name}-lambda"
  description      = "${var.name}-lambda"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda.lambda_handler"
  runtime          = "python3.8"
  timeout          = 10
}

resource "aws_cloudwatch_log_group" "lambda_cloudwatch_log_group" {
  name              = "/aws/lambda/${var.name}-lambda"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.name}-lambda-role"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [{
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow"
      }]
    }
  EOF

  inline_policy {
    name   = "${var.name}-lambda-policy"
    policy = <<-EOF
      {
        "Version": "2012-10-17",
        "Statement": [{
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": [
            "*"
          ]
        }]
      }
    EOF
  }

}
