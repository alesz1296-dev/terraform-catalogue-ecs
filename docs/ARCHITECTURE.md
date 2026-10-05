# Architecture

## High-level request flow

```text
Client
  |
  v
Application Load Balancer
public subnets
  |
  v
ECS Service
private subnets
  |
  v
Fargate Task
  |
  v
API Container
```

The API container will run a FastAPI version of the Terraform Catalogue API.

For v1, the API returns local in-memory catalogue data. Later versions can connect to DynamoDB or another data source.

The ALB is the public entry point. ECS tasks should not be directly reachable from the public internet.

## Network placement

- Public subnets: Application Load Balancer.
- Private subnets: ECS Fargate tasks.
- ALB security group: allows inbound HTTP from the internet.
- ECS task security group: allows inbound traffic only from the ALB security group.

Private ECS tasks need a path to AWS services for image pulls and logs:

- ECR API
- ECR Docker registry
- CloudWatch Logs
- S3 access used by ECR image layers

This project will use VPC endpoints instead of NAT Gateway for this outbound path.

Planned endpoint pattern:

- Interface endpoint for ECR API.
- Interface endpoint for ECR Docker.
- Interface endpoint for CloudWatch Logs.
- Gateway endpoint for S3.

## Image deployment flow

```text
Local source code
  |
  v
Docker build
  |
  v
Local Docker image
  |
  v
Amazon ECR
  |
  v
ECS Task Definition
  |
  v
ECS Service starts Fargate task
```

## Main components

### ECR Repository

Stores the Docker image that ECS pulls when starting tasks.

Status: created.

### ECS Cluster

Logical home for ECS services and tasks.

Status: created.

### ECS Task Definition

Defines the container image, CPU, memory, port mappings, execution role, and logging configuration.

Status: created.

The first task definition revision is:

```text
terraform-catalogue-ecs-dev-task:1
```

### Application Load Balancer

Receives external HTTP traffic and forwards requests to healthy ECS tasks.

Status: pending.

### ECS Service

Maintains the desired number of running tasks and connects the tasks to the target group.

Status: pending.

### Fargate Task

Runs the container without managing EC2 instances.

Status: pending.

### CloudWatch Logs

Stores logs emitted by the running container.

Status: log group created.

## Initial endpoint plan

- `/` returns basic service metadata.
- `/health` returns a health check response.
- `/modules` returns Terraform module catalogue data.
- `/modules/{module_id}` returns one Terraform module by id.

Optional `/modules` query filters:

- `category`
- `difficulty`
- `service`

## Platform evolution

```text
Project I
Static Terraform Catalogue website
  |
  v
Project II
Serverless Terraform Catalogue API
  |
  v
Project III
Containerized Terraform Catalogue API on ECS Fargate
```

## Cost considerations

The ALB and Fargate task can create ongoing monthly cost while running.

Cost-control approach:

- Run one task only.
- Use small CPU and memory values.
- Destroy resources when not testing.
- Use VPC endpoints instead of NAT Gateway.
- Avoid RDS in v1.

## Cleanup model

This project is not intended to run continuously.

After validating that the ALB can reach the ECS Fargate task and that logs appear in CloudWatch, the infrastructure should be destroyed with Terraform.

The long-term artifact is the code, Terraform configuration, documentation, and validation evidence, not the running AWS resources.
