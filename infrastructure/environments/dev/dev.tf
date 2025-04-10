# Cognito
module "cognito" {
  source = "../modules/cognito"
  env    = var.env
}

# API Gateway
module "api_gateway" {
  source = "../modules/api_gateway"
  env    = var.env
  stage_name = "dev"
  // TODO add order service invoke ARN when initializing the module
  order_service_lambda_invoke_arn = ""

  cognito_authorizer_id = module.cognito.authorizer_id
  request_validator_id  = module.api_gateway.request_validator_id
  order_request_model_id = module.api_gateway.order_request_model_id
  throttling_burst_limit = 100
  throttling_rate_limit  = 50
}

# EventBridge
module "eventbridge" {
  source = "../modules/eventbridge"
  bus_name = "order_events"

  # project-specific rules
  rules = {

    "order-created-to-inventory" = {
      pattern = jsonencode({
        "detail-type" = ["OrderCreated"]
        "source" = ["order-service"]
      })
      // TODO add lambda ARN of SQS -> inventory service
      lambda_arn = ""
    },

    "inventory-reserved-to-payment" = {
      pattern = jsonencode({
        "detail-type" = ["InventoryReserved"]
        "source" = ["inventory-service"]
      })
      // TODO add lambda ARN of SQS -> payment service
      lambda_arn = ""
    },
    "inventory-unavailable-to-order" = {
      pattern = jsonencode({
        "detail-type" = ["InventoryUnavailable"]
        "source" = ["inventory-service"]
      })
      // TODO add lambda ARN of order service to handle order status
      lambda_arn = ""
    },

    "payment-processed-to-order" = {
      pattern = jsonencode({
        "detail-type" = ["PaymentProcessed"]
        "source" = ["payment-service"]
      })
      // TODO add lambda ARN of order service to handle order status
      lambda_arn = ""
    },
    "payment-failed-to-order" = {
      pattern = jsonencode({
        "detail-type" = ["PaymentFailed"]
        "source" = ["payment-service"]
      })
      // TODO add lambda ARN of order service to handle order status
      lambda_arn = ""
    },
    "payment-failed-to-inventory" = {
      pattern = jsonencode({
        "detail-type" = ["PaymentFailed"]
        "source" = ["payment-service"]
      })
      // TODO add lambda ARN of inventory service to handle inventory rollback
      lambda_arn = ""
    },

    "order-confirmed" = {
      pattern = jsonencode({
        "detail-type" = ["OrderConfirmed"]
        "source" = ["order-service"]
      })
      // TODO add lambda ARN of shipping service to handle order shipping
      lambda_arn = ""
    },

  }
}
