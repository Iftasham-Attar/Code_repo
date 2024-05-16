provider "aws" {
  region = "us-west-2"  # Set your desired AWS region
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = "Private S3 Bucket"
  }
}

resource "aws_s3_bucket_policy" "private_bucket_policy" {
  bucket = aws_s3_bucket.private_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = var.iam_user_arn
        }
        Action    = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource  = [
          "${aws_s3_bucket.private_bucket.arn}/docs/*"
        ]
      }
    ]
  })
}
