terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state backend - S3 with DynamoDB locking
  # Bucket and table are created once, manually or via a small bootstrap stack,
  # before running this configuration.
  backend "s3" {
    bucket         = "terraform-challenge-state-dev"
    key            = "website/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-challenge-locks-dev"
    encrypt        = true
  }
}
