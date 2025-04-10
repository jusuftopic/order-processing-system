resource "aws_api_gateway_authorizer" "orders" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_user_pool_arn]
}
