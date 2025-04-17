# Order Service DynamoDB Table
resource "aws_dynamodb_table" "orders" {
  name = "orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Service = "order-service"
  }
}

# Inventory Service DynamoDB Table
resource "aws_dynamodb_table" "inventory" {
  name = "inventory"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "inventoryId"

  attribute {
    name = "inventoryId"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Service = "inventory-service"
  }
}

# Payment Service DynamoDB Table
resource "aws_dynamodb_table" "payment" {
  name = "payment"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "paymentId"

  attribute {
    name = "paymentId"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Service = "payment-service"
  }
}


