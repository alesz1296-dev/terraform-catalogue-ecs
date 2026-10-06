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


# ECS task defintions vars
variable "container_port" {
  description = "Port exposed by the container."
  type        = number
  default     = 8000
}

variable "alb_listener_port" {
  description = "Port on which the ALB listens for incoming traffic."
  type        = number
  default     = 80
}

variable "http_protocol" {
  description = "Protocol used by the ALB listener."
  type        = string
  default     = "HTTP"
}


variable "container_image_tag" {
  description = "Docker image tag deployed by the ECS task definition."
  type        = string
  default     = "dev-1"
}

# Cost-control toggles
variable "enable_vpc_endpoints" {
  description = "Create VPC endpoints for private ECS task access to AWS services."
  type        = bool
  default     = false
}

variable "enable_load_balancer" {
  description = "Create Application Load Balancer, target group, and listener."
  type        = bool
  default     = false
}

variable "enable_ecs_service" {
  description = "Create ECS service and run Fargate tasks."
  type        = bool
  default     = false
}

# VPCs

variable "cidr_block" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.0.0.0/16"
}


variable "availability_zones" {
  description = "Availability zones used by the project subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
