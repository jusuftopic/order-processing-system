output "inventory_sqs_arn" {
  value = aws_sqs_queue.inventory_fifo.arn
}

output "payment_sqs_arn" {
  value = aws_sqs_queue.payment_fifo.arn
}