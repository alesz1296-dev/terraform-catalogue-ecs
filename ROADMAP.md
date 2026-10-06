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
- Create Application Load Balancer. Completed.
- Create target group. Completed.
- Configure target group health check path `/health`. Completed.
- Create listener. Completed.
- Create ECS service. Completed.
- Run ECS tasks in private subnets. Completed.
- Test ALB endpoint. Completed.

## Milestone 7: Load balancing

- Create Application Load Balancer. Completed.
- Create target group. Completed.
- Configure health check path `/health`. Completed.
- Create HTTP listener on port 80. Completed.
- Connect listener to target group. Completed.

## Milestone 8: ECS service

- Create ECS service. Completed.
- Run one Fargate task. Completed.
- Place task in private subnets. Completed.
- Attach service to ALB target group. Completed.
- Wait for service to become stable. Completed.

## Milestone 9: Validation

- Open ALB DNS name. Completed.
- Test `/`. Completed.
- Test `/health`. Completed.
- Test `/modules`. Completed.
- Test `/modules/s3-static-site`. Completed.
- Confirm logs appear in CloudWatch. Completed.
- Document test results. Completed.

## Milestone 10: Cleanup

- Run `terraform destroy`.
- Confirm ALB, ECS service, endpoints, and networking are removed.
- Optionally delete old ECR images.
- Document cleanup result.

As of 10/8/2026 Milestone 10 was achieved.

## Optional enhancements

- HTTPS with ACM.
- Custom domain with Route 53.
- HTTP to HTTPS redirect.
- AWS WAF for basic application-layer protection.
- Rate limiting or managed WAF rules.
- Autoscaling.
- CI/CD deployment.
- DynamoDB integration.
- Reuse the Project II DynamoDB table or create a separate table.
- ECS service autoscaling.
- Container vulnerability scanning.
- Restricted VPC endpoint policies.
- Remote encrypted Terraform state.

## Future production-minded security layer

- Add Route 53 custom domain.
- Request or import ACM certificate.
- Add HTTPS listener on port 443.
- Redirect HTTP port 80 to HTTPS.
- Add AWS WAF association to the Application Load Balancer.
- Review security group egress restrictions.
- Review endpoint policies for ECR, CloudWatch Logs, and S3.
- Move Terraform state to a remote encrypted backend.
