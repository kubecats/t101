provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "hss3bucket" {
  bucket = "hs-t101study-tfstate-week3"
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "hss3bucket_versioning" {
  bucket = aws_s3_bucket.hss3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "hsdynamodbtable" {
  name         = "terraform-locks-week3"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.hss3bucket.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.hsdynamodbtable.name
  description = "The name of the DynamoDB table"
}