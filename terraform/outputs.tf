
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnets" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.main.name
}

output "launch_template_id" {
  value = aws_launch_template.windows.id
}

output "artifact_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}
