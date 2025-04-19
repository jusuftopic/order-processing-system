variable "bus_arn" {
  description = "EventBridge bus ARN"
  type = string
}

variable "inventory_lambda_arn" {
  description = "Lambda ARN for inventory processing"
  type = string
}

variable "payment_lambda_arn" {
  description = "Lambda ARN for payment processing"
  type = string
}