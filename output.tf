
output "alb_dns" {
  description = "ALB DNS name to reach the Hello World service"
  value       = module.ecs.alb_dns
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}