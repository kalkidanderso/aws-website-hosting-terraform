output "cloudfront_domain_name" {
  description = "Stable CloudFront endpoint for the S3-hosted site"
  value       = module.s3_cloudfront.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  value = module.s3_cloudfront.cloudfront_distribution_id
}

output "s3_bucket_name" {
  value = module.s3_cloudfront.bucket_name
}

output "ec2_public_ip" {
  description = "Stable Elastic IP for the EC2-hosted site"
  value       = module.ec2_nginx.public_ip
}
