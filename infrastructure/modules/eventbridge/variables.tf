variable "bus_name" {
  description = "Name of the custom EventBridge bus"
  type = string
}

variable "rules" {
  description = "Map of event rules to target ARNs"
  type = map(object({
    pattern  = string
    target_arn = string
  }))
}