# Terraform Catalogue Container API

Project III in the AWS/DevOps portfolio roadmap.

This project is the containerized evolution of the Terraform Catalogue platform.

The goal is to take the same API concept from Project II and redeploy it using Docker, Amazon ECR, Amazon ECS Fargate, an Application Load Balancer, CloudWatch Logs, IAM, and Terraform.

This keeps the portfolio of AWS mini projects consistent:

- Project I: Terraform Catalogue static website on S3 and CloudFront.
- Project II: Terraform Catalogue serverless API on API Gateway, Lambda, and DynamoDB.
- Project III: Terraform Catalogue container API on ECS Fargate.

The main focus is AWS container deployment, networking, load balancing, IAM roles, logs, and Terraform-managed infrastructure.

## Target outcome

By the end of v1, this project should include the following features:

- A small Terraform Catalogue API running locally with Docker.
- A Docker image pushed to Amazon ECR.
- An ECS Fargate service running the container.
- An Application Load Balancer exposing the service.
- CloudWatch Logs collecting container logs.
- Terraform managing the AWS infrastructure.
- Clear documentation of architecture decisions and tradeoffs.

## Planned application

The application should stay simple. A small Python FastAPI service is enough for v1.

For the first version, we will reuse the same domain model from Project II:

- Terraform module name.
- Category.
- Difficulty.
- AWS services used.
- Service features.
- Use cases.
- Description.

Possible endpoints:

- `GET /`
- `GET /health`
- `GET /modules`
- `GET /modules/{module_id}`

The `/modules` endpoint also supports simple optional filters:

- `category`
- `difficulty`
- `service`

The application itself is not the main focus. The AWS infrastructure around the container is the main focus.

For v1, the API can use local in-memory sample data. A database can be added later if we want to compare containerized app persistence options.

## Main AWS services

- Amazon ECR
- Amazon ECS
- AWS Fargate
- Application Load Balancer
- CloudWatch Logs
- IAM
- VPC, subnets, route tables, internet gateway, and security groups

## Cost posture

This project can cost more than the static website and serverless API projects because it uses always-running infrastructure.

For v1, the design should stay cost-conscious:

- Use the smallest practical Fargate task size.
- Run one desired task only.
- Use VPC endpoints instead of NAT Gateway for private task access to AWS services.
- Avoid RDS for the first version.
- Destroy infrastructure when not actively testing.

## Deployment lifecycle

This project should follow a deploy-test-destroy workflow:

```text
Build locally
  |
  v
Push image to ECR
  |
  v
terraform apply
  |
  v
Validate ECS, ALB, and CloudWatch Logs
  |
  v
terraform destroy
```

The goal is to keep the source code, Terraform configuration, documentation, and validation notes in GitHub, not to keep the AWS resources running continuously.
