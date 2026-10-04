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