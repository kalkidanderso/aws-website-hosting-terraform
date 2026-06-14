variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for this account (prod account)"
  type        = string
  default     = "prod"
}

variable "bucket_name" {
  description = "S3 bucket name for the static site (must be globally unique)"
  type        = string
  default     = "terraform-challenge-prod-site"
}

variable "ssh_key_name" {
  description = "SSH key pair name in the prod AWS account"
  type        = string
  default     = "prod-key"
}

variable "domain_name" {
  description = "Optional custom domain for prod"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "Optional ACM cert ARN for prod (us-east-1, for CloudFront)"
  type        = string
  default     = ""
}
