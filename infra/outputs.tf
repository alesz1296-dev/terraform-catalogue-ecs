# ECS
output "ecr_repository_name" {
  description = "Name of the ECR repository."
  value       = aws_ecr_repository.catalogue.name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository used for Docker tagging and pushing."
  value       = aws_ecr_repository.catalogue.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository."
  value       = aws_ecr_repository.catalogue.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster."
  value       = aws_ecs_cluster.catalogue.name
}
output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.catalogue.arn
}

output "ecs_log_group_name" {
  description = "CloudWatch log group used by ECS container logs."
  value       = aws_cloudwatch_log_group.ecs_cluster.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition."
  value       = aws_ecs_task_definition.catalogue.arn
}

output "ecs_task_definition_family" {
  description = "Family name of the ECS task definition."
  value       = aws_ecs_task_definition.catalogue.family
}

# VPCs
output "vpc_id" {
  description = "ID of the project VPC."
  value       = aws_vpc.catalogue.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the project VPC."
  value       = aws_vpc.catalogue.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets used by the ALB."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets used by ECS tasks."
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway attached to the VPC."
  value       = aws_internet_gateway.catalogue.id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}


#SGs
output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  description = "Security group ID for ECS Fargate tasks."
  value       = aws_security_group.ecs_tasks.id
}

output "vpc_endpoints_security_group_id" {
  description = "Security group ID used by VPC interface endpoints."
  value       = aws_security_group.vpc_endpoints.id
}
#endpoints
output "s3_vpc_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint."
  value       = aws_vpc_endpoint.s3.id
}

output "ecr_api_vpc_endpoint_id" {
  description = "ID of the ECR API interface VPC endpoint."
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_vpc_endpoint_id" {
  description = "ID of the ECR Docker interface VPC endpoint."
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "logs_vpc_endpoint_id" {
  description = "ID of the CloudWatch Logs interface VPC endpoint."
  value       = aws_vpc_endpoint.cloudwatch_logs.id
}

#ALB

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.catalogue.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.catalogue.arn
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer."
  value       = aws_lb.catalogue.zone_id
}

output "target_group_arn" {
  description = "ARN of the ALB target group."
  value       = aws_lb_target_group.catalogue.arn
}

output "target_group_name" {
  description = "Name of the ALB target group."
  value       = aws_lb_target_group.catalogue.name
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener."
  value       = aws_lb_listener.catalogue.arn
}
