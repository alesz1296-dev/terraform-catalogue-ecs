variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "terraform-catalogue-ecs"
}


variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

