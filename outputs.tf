output "apigw_update_url" {
  description = "invoke url"
  value       = "${aws_apigatewayv2_stage.prod_stage.invoke_url}/update"
}
