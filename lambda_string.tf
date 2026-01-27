resource "aws_lambda_function" "update_dynamic_content" {
  function_name = "update-dynamic-content"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/scripts/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/lambda.zip")

  timeout = 5
}