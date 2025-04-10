resource "aws_api_gateway_rest_api" "orders_api" {
  name = "orders-api-${var.env}"
  description = "Order Processing API"
  endpoint_configuration {
    # lower costs and lower latency - intended for regional clients
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "orders_resource" {
  parent_id   = aws_api_gateway_rest_api.orders_api.root_resource_id
  path_part   = "orders"
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
}

resource "aws_api_gateway_method" "post_orders" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.orders.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.orders_resource.id
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id

  request_models = {
    "application/json" = aws_api_gateway_model.order_request.id
  }

  request_validator_id = aws_api_gateway_request_validator.body.id
}

resource "aws_api_gateway_model" "order_request" {
  rest_api_id  = aws_api_gateway_rest_api.orders_api.id
  name         = "OrderRequest"
  description  = "JSON schema for order creation"
  content_type = "application/json"
  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#",
    "type"    = "object",
    "properties" = {
      "items" = {
        "type" = "array",
        "items" = {
          "type" = "object",
          # productId and quantity are mandatory in order to place a order
          "properties" = {
            "productId" = { "type" = "string" },
            "quantity"  = { "type" = "integer", "minimum": 1 }
          },
          "required" = ["productId", "quantity"]
        }
      }
    },
    "required" = ["items"]
  })
}

resource "aws_api_gateway_request_validator" "body" {
  name        = "body-validator"
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  validate_request_body = true
  validate_request_parameters = false
}

resource "aws_api_gateway_method_settings" "orders_method_settings" {
  method_path = "*/*"
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  stage_name  = aws_api_gateway_deployment.orders_deployment.stage_name

  settings {
    # limit for short burst spikes (milliseconds)
    throttling_burst_limit = var.throttling_burst_limit
    # limit for long term traffic control (requests per second)
    throttling_rate_limit  = var.throttling_rate_limit
  }
}

resource "aws_api_gateway_integration" "order_service" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_resource.id
  http_method = aws_api_gateway_method.post_orders.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri = var.order_service_lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "orders_deployment" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.post_orders,
    aws_api_gateway_integration.order_service,
    aws_api_gateway_method_settings.orders_method_settings
  ]
}

resource "aws_api_gateway_stage" "orders_stage" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  deployment_id = aws_api_gateway_deployment.orders_deployment.id
}