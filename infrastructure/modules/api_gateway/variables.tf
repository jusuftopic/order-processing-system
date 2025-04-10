variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  type        = string
}

variable "throttling_burst_limit" {
  description = "Burst limit for API Gateway"
  type        = number
  validation {
    condition     = var.throttling_burst_limit > 0
    error_message = "Throttling burst limit must be greater than 0"
  }
}

variable "throttling_rate_limit" {
  description = "Rate limit for API Gateway"
  type        = number
  validation {
    condition     = var.throttling_rate_limit > 0
    error_message = "Throttling rate limit must be greater than 0"
  }
}

variable "order_service_lambda_invoke_arn" {
  description = "Lambda function ARN for the order service"
  type        = string
}

variable "stage_name" {
  description = "Stage name for the API Gateway"
  type        = string
}