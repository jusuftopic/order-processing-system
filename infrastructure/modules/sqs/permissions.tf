locals {
  eventbridge_statement_template = {
    Sid    = "AllowEventBridgeSendMessage"
    Effect = "Allow"
    Principal = {
      Service = "events.amazonaws.com"
    }
    Action = "sqs:SendMessage"
    Condition = {
      ArnEquals = {
        "aws:SourceArn" = var.bus_arn
      }
    }
  }

  lambda_statement_template = {
    Effect = "Allow"
    Action = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
  }
}

resource "aws_sqs_queue_policy" "inventory_fifo_policy" {
  queue_url = aws_sqs_queue.inventory_fifo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id = "InventoryQueuePolicy"
    Statement = [
      local.eventbridge_statement_template,
      merge(
        local.lambda_statement_template,
        {
          Sid       = "AllowLambdaConsume"
          Principal = { AWS = var.inventory_lambda_arn }
          Resource  = aws_sqs_queue.inventory_fifo.arn
        }
      )
    ]
  })
}

resource "aws_sqs_queue_policy" "payment_fifo_policy" {
  queue_url = aws_sqs_queue.payment_fifo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id = "PaymentQueuePolicy"
    Statement = [
      local.eventbridge_statement_template,
      merge(
        local.lambda_statement_template,
        {
          Sid       = "AllowLambdaConsume"
          Principal = { AWS = var.payment_lambda_arn }
          Resource  = aws_sqs_queue.payment_fifo.arn
        }
      )
    ]
  })
}