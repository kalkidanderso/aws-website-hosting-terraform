terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state backend - S3 with DynamoDB locking
  # Separate state bucket/table in the prod AWS account.
  backend "s3" {
    bucket         = "terraform-challenge-state-prod"
    key            = "website/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-challenge-locks-prod"
    encrypt        = true
  }
}
