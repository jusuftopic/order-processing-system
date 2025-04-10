variable "bus_name" {
  description = "Name of the custom EventBridge bus"
  type = string
}

variable "rules" {
  description = "Map of event rules to Lambda ARNs"
  type = map(object({
    pattern  = string
    lambda_arn = string
  }))
}