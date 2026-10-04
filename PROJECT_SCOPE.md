# Project Scope

## Project name

Terraform Catalogue Container API

## Purpose

Build a small production-minded container deployment on AWS using ECS Fargate.

This project continues the Terraform Catalogue platform from the previous projects. Instead of creating an unrelated Docker app, we will redeploy the catalogue API as a containerized service.

This project is intended for working with Docker image deployment, ECS services, load balancing, cloud networking, IAM roles, and operational visibility.

## In scope for v1

- Simple containerized Terraform Catalogue API.
- FastAPI application with basic catalogue endpoints.
- Local in-memory module data for the first version.
- Dockerfile for local container build.
- ECR repository for image storage.
- ECS cluster.
- ECS task definition.
- ECS service using Fargate.
- Application Load Balancer.
- Target group and listener.
- CloudWatch log group.
- IAM task execution role.
- VPC networking.
- Public subnets for the ALB.
- Private subnets for ECS tasks.
- Security groups for ALB and ECS.
- Terraform-managed infrastructure.
- Manual deployment steps documented.

## Out of scope for v1

- Kubernetes.
- EKS.
- RDS or persistent relational database.
- DynamoDB integration from the container.
- Secrets Manager.
- Custom domain.
- HTTPS certificate.
- CI/CD pipeline.
- Blue/green deployment.
- Autoscaling.
- Private-only service design.

These may be added later as enhancements or separate projects.

## Success criteria

- The app runs locally in Docker.
- The app exposes `/`, `/health`, `/modules`, and `/modules/{module_id}`.
- The Docker image is pushed to ECR.
- Terraform creates the required AWS infrastructure.
- ECS service reaches a stable running state.
- The ALB endpoint returns a successful response from `/health`.
- Logs appear in CloudWatch.
- README documents how to deploy, test, and clean up.
