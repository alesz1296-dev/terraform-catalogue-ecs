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

Current VPC foundation:

- VPC CIDR: `10.0.0.0/16`.
- Public subnet 1: `10.0.1.0/24`.
- Public subnet 2: `10.0.2.0/24`.
- Private subnet 1: `10.0.11.0/24`.
- Private subnet 2: `10.0.12.0/24`.
- Public route table: default route to the Internet Gateway.
- Private route table: no default internet route.

Security group flow:

```text
Internet
  |
  | HTTP 80
  v
ALB security group
  |
  | TCP 8000
  v
ECS task security group
  |
  v
FastAPI container
```

The ECS task security group references the ALB security group as its inbound source. This means the application container should only receive inbound traffic through the load balancer path.

Private ECS tasks need a path to AWS services for image pulls and logs:

- ECR API
- ECR Docker registry
- CloudWatch Logs
- S3 access used by ECR image layers

This project will use VPC endpoints instead of NAT Gateway for this outbound path.

Planned endpoint pattern:

- Interface endpoint for ECR API. Created and validated.
- Interface endpoint for ECR Docker. Created and validated.
- Interface endpoint for CloudWatch Logs. Created and validated.
- Gateway endpoint for S3. Created and validated.

All four endpoints were checked and are in the `available` state.

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

Status: created and validated.

Security group: created.

Next load balancing resources:

- Application Load Balancer. Completed.
- Target group. Completed.
- Health check path: `/health`. Completed.
- HTTP listener on port 80. Completed.
- Listener forwarding rule to the target group. Completed.

Future production-minded edge layer:

```text
Internet
  |
  v
Route 53 / Custom Domain
  |
  v
AWS WAF
  |
  v
Application Load Balancer
  |
  | HTTPS :443
  v
ECS Fargate tasks
```

Planned security enhancements for a production-like version:

- ACM certificate for TLS.
- HTTPS listener on port 443.
- HTTP port 80 redirect to HTTPS.
- AWS WAF attached to the Application Load Balancer.
- Managed WAF rules or rate limiting.
- Endpoint policy review for private AWS service access.
- Remote encrypted Terraform state.

### ECS Service

Maintains the desired number of running tasks and connects the tasks to the target group.

Status: created and validated.

### Fargate Task

Runs the container without managing EC2 instances.

Status: running and validated.

Security group: created.

Planned service behavior:

- Run one Fargate task. Completed.
- Place the task in private subnets. Completed.
- Attach the service to the ALB target group. Completed.
- Wait for the service to reach a stable state. Completed.

### CloudWatch Logs

Stores logs emitted by the running container.

Status: log group created and container logs confirmed.

## v1 validation evidence

The v1 architecture was validated successfully.

ECS service state:

```text
Status:  ACTIVE
Desired: 1
Running: 1
Pending: 0
```

Target group state:

```text
Target health: healthy
Target port: 8000
Target placement: private subnet
```

Application endpoint tests:

```text
GET /                         -> 200 OK
GET /health                   -> 200 OK
GET /modules                  -> 200 OK
GET /modules/s3-static-site   -> 200 OK
```

CloudWatch Logs:

```text
ALB health checks reached /health.
Manual requests reached /, /health, /modules, and /modules/s3-static-site.
Container logs were written under the ECS log group.
```

Validated request path:

```text
Internet
  |
  v
Application Load Balancer
  |
  v
ALB Target Group
  |
  v
Private ECS Fargate Task
  |
  v
FastAPI Container :8000
```

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
