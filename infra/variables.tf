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

variable "manager" {
  description = "Tool managing these resources."
  type        = string
  default     = "terraform"
}

variable "log_retention_days" {
  default = 1
}

locals {
  name_prefix = "${var.project_name}-${var.environment}" ##need to update this in old definitions
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = var.manager
  }
}


# ECS task defintions vars
variable "container_port" {
  description = "Port exposed by the container."
  type        = number
  default     = 8000
}

variable "container_image_tag" {
  description = "Docker image tag deployed by the ECS task definition."
  type        = string
  default     = "dev-1"
}