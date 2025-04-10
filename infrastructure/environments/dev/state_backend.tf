resource "aws_s3_bucket" "terraform_state" {
  bucket = "your-company-tfstate-${var.env}"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:DeleteObject"
        Resource  = "${aws_s3_bucket.terraform_state.arn}/*"
      }
    ]
  })
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}