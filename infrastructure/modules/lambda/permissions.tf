resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.order_service_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.orders_api_execution_arn}/*/*"
}