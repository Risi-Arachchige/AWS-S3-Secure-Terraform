output "s3_bucket_name" { # display the bucket name
  value = aws_s3_bucket.secure_bucket.bucket
}

output "s3_bucket_arn" { # display the bucket arn
  value = aws_s3_bucket.secure_bucket.arn
}
