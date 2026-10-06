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

- Create ECR repository. Completed.
- Authenticate Docker to ECR. Completed.
- Tag the local image. Completed.
- Push image to ECR. Completed.

## Phase 3: ECS foundation

- Create ECS cluster. Completed.
- Create task execution role. Completed.
- Attach ECS task execution policy. Completed.
- Create CloudWatch log group. Completed.
- Create ECS task definition. Completed.
- Confirm task definition revision is created. Completed.

## Phase 4: Load-balanced ECS service

- Create VPC networking. Completed.
- Create public subnets for the ALB. Completed.
- Create private subnets for ECS tasks. Completed.
- Create Internet Gateway. Completed.
- Create public and private route tables. Completed.
- Create security group for ALB. Completed.
- Create security group for ECS tasks. Completed.
- Restrict ECS task inbound traffic to the ALB security group. Completed.
- Create VPC endpoints for ECR, CloudWatch Logs, and S3. Completed.
- Validate all four VPC endpoints are available. Completed.
- Create Application Load Balancer.
- Create target group.
- Configure target group health check path `/health`.
- Create listener.
- Create ECS service.
- Run ECS tasks in private subnets.
- Test ALB endpoint.

## Milestone 7: Load balancing

- Create Application Load Balancer.
- Create target group.
- Configure health check path `/health`.
- Create HTTP listener on port 80.
- Connect listener to target group.

## Milestone 8: ECS service

- Create ECS service.
- Run one Fargate task.
- Place task in private subnets.
- Attach service to ALB target group.
- Wait for service to become stable.

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
