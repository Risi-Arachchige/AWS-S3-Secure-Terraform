# Secure AWS S3 Bucket with Terraform

This project sets up a secure Amazon S3 bucket using Terraform, implementing AWS security best practices. Features include bucket versioning, server-side encryption, and access logging.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Configuration Details](#configuration-details)
- [Variables](#variables)
- [Outputs](#outputs)
- [Step-by-Step Guide](#step-by-step-guide)
- [Security Best Practices](#security-best-practices)
- [Conclusion](#conclusion)

## Overview

This Terraform configuration creates a secure S3 bucket in AWS with enforced privacy settings, logging, and encryption. The configuration adheres to security best practices, helping ensure data integrity and confidentiality.

## Prerequisites

- **Terraform**: Installed on your machine (version 1.0 or higher).
- **AWS Account**: With permissions to create S3 buckets and configure security settings.

## Project Structure

/secure-s3-bucket ├── main.tf # Main Terraform configuration file ├── variables.tf # Variable definitions for customizations ├── outputs.tf # Outputs to retrieve bucket details └── README.md # Project README file


## Configuration Details

The Terraform configuration includes:

- **AWS Provider**: Defines the region for resource creation.
- **S3 Bucket**: Configures a private S3 bucket with tagging for easy organization.
- **Bucket Security**: Implements ACL to restrict public access and enables server-side encryption with `AES256`.
- **Versioning**: Enables bucket versioning for data recovery and rollback options.
- **Logging**: Sets up access logging for monitoring and compliance.

## Variables

The `variables.tf` file includes customizable variables for your S3 bucket:

```
variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  default     = "risi-test-secure-bucket-v1"
  type        = string
}
```
- **region**: Specifies the AWS region for resource deployment.
- **bucket_name**: Defines a unique name for the S3 bucket.


# Outputs

The outputs.tf file provides key information about the created S3 bucket.
```
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.arn
}
```
- **s3_bucket_name**: Outputs the name of the S3 bucket.
- **s3_bucket_arn**: Outputs the ARN (Amazon Resource Name) of the S3 bucket.


# Step-by-Step Guide
## 1. Configure the AWS Provider

Specify the AWS region for the project. Modify as needed in the variables.tf file.
```
provider "aws" {
  region = var.region
}
```
## 2. Create the S3 Bucket

Define the secure S3 bucket with tags for easy identification.
```
resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name

  tags = {
    name        = "test bucket"
    environment = "Dev"
  }
}
```

## 3. Block Public Access with ACL

Set the ACL to private to prevent public access to the bucket.
```
resource "aws_s3_bucket_acl" "secure_bucket_acl" {
  bucket = aws_s3_bucket.secure_bucket.id
  acl    = "private"
}
```

## 4. Enable Versioning

Turn on versioning to maintain data history and enable object recovery.
```
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

## 5. Enable Server-Side Encryption

Apply server-side encryption using AES256 for data confidentiality.
```
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

## 6. Enable Access Logging

Configure access logging to a separate bucket to monitor data access and ensure compliance.
```
resource "aws_s3_bucket_logging" "secure_bucket_logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = "test-target-bucket-name-v1-risi" # Use a different bucket for logging
  target_prefix = "log/"
}
```


# Security Best Practices

- **Block Public Access**: Setting ACL to private ensures that the bucket contents are not publicly accessible.
- **Enable Server-Side Encryption**: Encrypts data at rest with AES256, ensuring data confidentiality.
- **Versioning**: Keeps track of file changes and deletions, allowing data recovery if needed.
- **Access Logging**: Helps monitor bucket access and manage compliance requirements.


# Conclusion

This Terraform project provides a secure configuration for an AWS S3 bucket, with enforced access controls, encryption, and logging. These settings ensure the S3 bucket meets security and compliance requirements for handling sensitive data.

Feel free to reach out if you have any questions or feedback!


# Finished Config File (main.tf)

```
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
```