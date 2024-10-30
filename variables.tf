variable "region" { # define the region
  description = "AWS Region"
  default     = "us-east-2"
}

variable "bucket_name" { # define the unipue bucket name
  default = "risi-test-secure-bucket-v1"
  type    = string
}