resource "aws_apigatewayv2_api" "dynamic_api" {
  name          = "UpdateDynamicStringAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.dynamic_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.update_dynamic_content.arn
  payload_format_version = "2.0"
}

#post
resource "aws_apigatewayv2_route" "post_update" {
  api_id    = aws_apigatewayv2_api.dynamic_api.id
  route_key = "POST /update"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id      = aws_apigatewayv2_api.dynamic_api.id
  name        = "prod"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_dynamic_content.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.dynamic_api.execution_arn}/*/*"
}
