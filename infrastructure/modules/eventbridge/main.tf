
resource "aws_cloudwatch_event_bus" "order_bus" {
  name = var.bus_name
}

resource "aws_cloudwatch_event_rule" "event_rules" {
  for_each = var.rules

  name = each.key
  event_pattern = each.value.pattern
  event_bus_name = aws_cloudwatch_event_bus.order_bus.name
}

resource "aws_cloudwatch_event_target" "targets" {
  for_each = var.rules

  arn  = each.value.lambda_arn
  rule = aws_cloudwatch_event_rule.event_rules[each.key].name
}