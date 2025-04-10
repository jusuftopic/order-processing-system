resource "aws_api_gateway_authorizer" "orders" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  authorizer_result_ttl_in_seconds = 300
  type          = "COGNITO_USER_POOLS"
  identity_source         = "method.request.header.Authorization"
  provider_arns = [var.cognito_user_pool_arn]
}
