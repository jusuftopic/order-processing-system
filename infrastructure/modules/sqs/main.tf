# DLQ for all FIFO queues
resource "aws_sqs_queue" "fifo_dlq" {
  name = "global-dlq.fifo"
  fifo_queue = true
  content_based_deduplication = true

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
  })
}

# Inventory FIFO queue
resource "aws_sqs_queue" "inventory_fifo" {
  name = "inventory-queue.fifo"
  fifo_queue = true
  content_based_deduplication = true
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.fifo_dlq.arn
    /* after 5 queue invocations, move message to DLQ */
    maxReceiveCount = 5
  })
}

# Payment FIFO queue
resource "aws_sqs_queue" "payment_fifo" {
  name = "payment-queue.fifo"
  fifo_queue = true
  content_based_deduplication = true
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.fifo_dlq.arn
    maxReceiveCount = 5
  })
}