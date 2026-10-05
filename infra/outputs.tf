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