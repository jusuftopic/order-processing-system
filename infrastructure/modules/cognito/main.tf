resource "aws_cognito_user_pool" "orders_user_pool" {
  name = "orders-user-pool-${var.env}"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

resource "aws_cognito_user_pool_client" "orders_user_pool_client" {
  name         = "orders-client-${var.env}"
  user_pool_id = aws_cognito_user_pool.orders_user_pool.id
  generate_secret = false

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                 = ["code"]
  allowed_oauth_scopes               = ["email", "openid"]
  supported_identity_providers       = ["COGNITO"]
}