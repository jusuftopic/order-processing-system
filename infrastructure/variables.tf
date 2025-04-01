variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "env" {
  description = "Environment (dev/prod)"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Valid values: dev, prod"
  }
}