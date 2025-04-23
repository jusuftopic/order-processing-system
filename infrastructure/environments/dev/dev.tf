# DynamoDB
module "dynamoDB" {
  source = "../modules/dynamodb"
  env    = var.env
}

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

# SQS
module "sqs" {
  source = "../modules/sqs"
  bus_arn = module.eventbridge.bus_arn
  // TODO add lambda arns
  inventory_lambda_arn =
  payment_lambda_arn =
  depends_on = [module.eventbridge]
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
      target_arn = module.sqs.inventory_sqs_arn
    },

    "inventory-reserved-to-payment" = {
      pattern = jsonencode({
        "detail-type" = ["InventoryReserved"]
        "source" = ["inventory-service"]
      })
      // TODO add lambda ARN of SQS -> payment service
      target_arn = module.sqs.payment_sqs_arn
    },
    "inventory-unavailable-to-order" = {
      pattern = jsonencode({
        "detail-type" = ["InventoryUnavailable"]
        "source" = ["inventory-service"]
      })
      // TODO add lambda ARN of order service to handle order status
      target_arn = ""
    },

    "payment-processed-to-order" = {
      pattern = jsonencode({
        "detail-type" = ["PaymentProcessed"]
        "source" = ["payment-service"]
      })
      // TODO add lambda ARN of order service to handle order status
      target_arn = ""
    },
    "payment-failed-to-order" = {
      pattern = jsonencode({
        "detail-type" = ["PaymentFailed"]
        "source" = ["payment-service"]
      })
      // TODO add lambda ARN of order service to handle order status
      target_arn = ""
    },
    "payment-failed-to-inventory" = {
      pattern = jsonencode({
        "detail-type" = ["PaymentFailed"]
        "source" = ["payment-service"]
      })
      // TODO add lambda ARN of inventory service to handle inventory rollback
      target_arn = ""
    },

    "order-confirmed" = {
      pattern = jsonencode({
        "detail-type" = ["OrderConfirmed"]
        "source" = ["order-service"]
      })
      // TODO add lambda ARN of shipping service to handle order shipping
      target_arn = ""
    }
  }
}
