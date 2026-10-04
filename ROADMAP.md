# Roadmap

## Phase 0: Design review

- Review request flow.
- Review container image flow.
- Review ECS concepts.
- Review how this project evolves the Project II API.
- Review Fargate pricing and cleanup strategy.
- Document the decision to run ECS tasks in private subnets.
- Document the decision to use VPC endpoints instead of NAT Gateway.
- Review VPC endpoints required for private ECS task image pulls and logging.

## Phase 1: Local container application

- Create a minimal FastAPI catalogue API.
- Reuse the Terraform module data model from Project II.
- Add endpoints for `/`, `/health`, `/modules`, and `/modules/{module_id}`.
- Add a Dockerfile.
- Build the image locally.
- Run the container locally.
- Test `/health`.

## Phase 2: Container registry

- Create ECR repository.
- Authenticate Docker to ECR.
- Tag the local image.
- Push image to ECR.

## Phase 3: ECS foundation

- Create ECS cluster.
- Create task execution role.
- Create CloudWatch log group.
- Create ECS task definition.

## Phase 4: Load-balanced ECS service

- Create VPC networking.
- Create VPC endpoints for ECR, CloudWatch Logs, and S3.
- Create security groups.
- Create Application Load Balancer.
- Create target group.
- Create listener.
- Create ECS service.
- Run ECS tasks in private subnets.
- Test ALB endpoint.

## Phase 5: Operations and documentation

- Confirm logs in CloudWatch.
- Document test commands.
- Document validation evidence.
- Document cleanup commands.
- Record design decisions.
- Review costs.
- Destroy infrastructure after validation.

## Phase 6: Optional enhancements

- HTTPS with ACM.
- Custom domain with Route 53.
- Autoscaling.
- CI/CD deployment.
- DynamoDB integration.
- Reuse the Project II DynamoDB table or create a separate table.
- ECS service autoscaling.
- Container vulnerability scanning.
