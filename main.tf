# Configure Provider

provider "aws" {
  region = "us-east-2" # select your prefered region
}

# Create the Secure S3 bucket resource

resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name # Replace the bucket with a unique name

  # Use S3 bucket tags to organize, manage, and secure your S3 resources effectively.
  tags = {
    name        = "test bucket"
    environment = "Dev"
  }
}

# block public access
resource "aws_s3_bucket_acl" "secure_bucket_acl" {
  bucket = aws_s3_bucket.secure_bucket.id
  acl    = "private"
}


# Enable versioning
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encription" {
  bucket = aws_s3_bucket.secure_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable access logging
resource "aws_s3_bucket_logging" "secure_bucket_logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = "test-target-bucket-name-v1-risi" # This should be a separate bucket (not the bucket you're configuring logging for)
  target_prefix = "log/"
}

# Block public access settings

resource "aws_s3_bucket_public_access_block" "secure_bucket_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure IAM Policy for Secure Access

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy for secure access to the S3 bucket"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.secure_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.secure_bucket.bucket}/*"
        ]
      }
    ]
  })
}


# Create IAM user
resource "aws_iam_user" "s3_user" {
  name = "s3_user"
}


# Attach policy to IAM user
resource "aws_iam_user_policy_attachment" "s3_user_policy_attachment" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
