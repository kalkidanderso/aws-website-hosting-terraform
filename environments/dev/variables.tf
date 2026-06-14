variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for this account (dev account)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "S3 bucket name for the static site (must be globally unique)"
  type        = string
  default     = "terraform-challenge-dev-site"
}

variable "ssh_key_name" {
  description = "SSH key pair name in the dev AWS account"
  type        = string
  default     = "dev-key"
}

variable "domain_name" {
  description = "Optional custom domain for dev"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "Optional ACM cert ARN for dev (us-east-1, for CloudFront)"
  type        = string
  default     = ""
}
