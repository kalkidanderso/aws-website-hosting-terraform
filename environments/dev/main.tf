module "s3_cloudfront" {
  source = "../../modules/s3-cloudfront"

  bucket_name         = var.bucket_name
  environment         = "dev"
  domain_name         = var.domain_name
  acm_certificate_arn = var.acm_certificate_arn

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

module "ec2_nginx" {
  source = "../../modules/ec2-nginx"

  environment  = "dev"
  ssh_key_name = var.ssh_key_name

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
