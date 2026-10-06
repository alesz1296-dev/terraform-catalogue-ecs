# Design Decisions

This file records architecture choices, tradeoffs, and reasoning for Project III.

## Continue the Terraform Catalogue platform

Project III will continue the same Terraform Catalogue concept instead of creating an unrelated Docker application.

Reasoning:

- Creates a stronger portfolio story.
- Shows the same product idea deployed across multiple AWS architecture patterns.
- Allows comparison between static hosting, serverless, containers, and later Kubernetes.
- Keeps the application domain familiar while the infrastructure becomes more advanced.

Tradeoff:

- Less variety in application themes.
- Requires careful documentation so each project still has a distinct infrastructure focus.

## ECS Fargate instead of EC2-backed ECS

ECS Fargate will be used for the first version.

Reasoning:

- Reduces server management overhead.
- Keeps focus on containers, tasks, services, networking, and load balancing.
- Avoids managing EC2 capacity, AMIs, and cluster instances.
- Fits the project goal of learning managed container deployment on AWS.

Tradeoff:

- Fargate can be more expensive than carefully managed EC2 for always-on workloads.
- Less control over the underlying compute layer.

EC2-backed ECS is unnecessary for the current scope and goal of this project.

## Small API instead of a complex application

The app should remain intentionally simple. The focus is to work with Fargate and containers in AWS.

Reasoning:

- The main focus is AWS infrastructure, not application complexity.
- A small API is enough to validate container deployment, health checks, routing, logs, and service availability.
- Reusing the Terraform Catalogue API concept keeps continuity with Project II.

Tradeoff:

- The application itself will not demonstrate advanced backend design in v1.

## Use in-memory sample data in v1

No RDS, DynamoDB integration, or persistent database will be included in the first version.

Reasoning:

- Keeps cost lower.
- Keeps the architecture focused on container deployment.
- Avoids adding stateful infrastructure before the ECS fundamentals are clear.
- Allows the container deployment path to be validated first.

Tradeoff:

- The app will be less realistic than a full production backend.
- Data will not persist outside the application code in v1.

This is acceptable because this small project is preparation for a full production-style project later on.

## Start with HTTP only

The first version will use an ALB HTTP listener.

Reasoning:

- Reduces initial complexity.
- Allows focus on ECS service networking and health checks first.

Tradeoff:

- HTTPS is expected in a production system and should be added later with ACM.

Future production enhancement:

- Add an ACM certificate.
- Add an HTTPS listener on port 443.
- Redirect HTTP port 80 to HTTPS.
- Consider Route 53 for a custom domain.

## Run ECS tasks in private subnets

ECS Fargate tasks will run in private subnets for this project.

The Application Load Balancer will be placed in public subnets and will forward traffic to the ECS tasks in private subnets.

Reasoning:

- Keeps application containers away from direct public internet exposure.
- Better matches common production ECS architecture.
- Forces clear understanding of ALB-to-task routing and security group design.
- Separates public entry points from private application workloads.

Tradeoff:

- Private tasks still need outbound access to pull images from ECR and send logs to CloudWatch.
- This requires VPC endpoints for the AWS services the task needs.
- VPC endpoints add more Terraform resources and design complexity.
- Avoiding NAT Gateway reduces the risk of recurring NAT hourly and data processing cost.

For v1, this remains acceptable because the project follows a deploy-test-destroy workflow.

## Separate public ALB access from private ECS task access

The VPC networking layer separates public and private responsibilities.

Current network foundation:

- Public subnets are reserved for the Application Load Balancer.
- Private subnets are reserved for ECS Fargate tasks.
- Public subnets use a route table with a default route to the Internet Gateway.
- Private subnets use a separate route table with no default internet route.

Security group design:

- The ALB security group allows inbound HTTP traffic from the internet on port 80.
- The ECS task security group allows inbound application traffic only from the ALB security group on the container port.
- ECS tasks are not directly reachable from the public internet.

Reasoning:

- Matches a common production ECS pattern.
- Keeps the public entry point separate from the private workload.
- Makes the security boundary clear and easier to explain.
- Prepares the architecture for ALB health checks and ECS service registration.

Tradeoff:

- Requires more networking resources than directly assigning public IPs to ECS tasks.
- Requires VPC endpoints for private ECS task access to ECR, CloudWatch Logs, and S3.

Future production enhancement:

- Place AWS WAF in front of the Application Load Balancer.
- Use managed WAF rules and/or rate limiting.
- Keep ECS tasks private and reachable only through the ALB target group.

## Use VPC endpoints instead of NAT Gateway

Private ECS tasks will use VPC endpoints instead of NAT Gateway for required AWS service access.

Reasoning:

- NAT Gateway has an always-on hourly charge and data processing charges.
- The project is a cost-conscious lab and does not need general-purpose internet egress from private subnets.
- ECS tasks mainly need access to AWS services such as ECR, CloudWatch Logs, and S3-backed ECR image layers.
- VPC endpoints allow private connectivity to those AWS services without routing through a NAT Gateway.

Planned endpoints for ECS image pull and logging:

- ECR API interface endpoint. Created and validated.
- ECR Docker interface endpoint. Created and validated.
- CloudWatch Logs interface endpoint. Created and validated.
- S3 gateway endpoint. Created and validated.

Tradeoff:

- More infrastructure resources to understand and manage.
- Endpoint policies and security groups must be configured correctly.
- If the container later needs general outbound internet access, this design would need to be revisited.

Validation result:

- All four required VPC endpoints were confirmed in the `available` state.
- This validates the private AWS service access path required for ECS image pulls and CloudWatch log delivery.
- The final proof will occur when the ECS service starts a Fargate task successfully without NAT Gateway.

Future production enhancement:

- Review and restrict VPC endpoint policies where practical.
- Review ECS task outbound rules and reduce broad egress where practical.

## Create ECS foundation before ECS service

The project creates the ECS foundation before creating the ECS service.

Completed foundation resources:

- ECR repository.
- ECS cluster.
- CloudWatch log group.
- ECS task execution role.
- ECS task execution role policy attachment.
- ECS task definition.

Reasoning:

- The ECS service depends on networking, security groups, target groups, and load balancer configuration.
- Creating the task definition first validates the container runtime configuration separately.
- This keeps the implementation easier to troubleshoot in layers.

Tradeoff:

- The task definition exists before any running task exists.
- More validation steps are needed before the application is reachable from AWS.

## Validate v1 through the ALB before cleanup

The v1 architecture was validated through the public Application Load Balancer before cleanup.

Validated behavior:

- ECS service reached `ACTIVE` status.
- ECS desired count was `1`.
- ECS running count was `1`.
- ECS pending count was `0`.
- ALB target group reported the private Fargate task as `healthy`.
- The ALB forwarded requests to the FastAPI container on port `8000`.
- `/`, `/health`, `/modules`, and `/modules/s3-static-site` returned successful responses.
- CloudWatch Logs received container logs for ALB health checks and manual API requests.

Reasoning:

- Validates that the private ECS task can run without a public IP.
- Confirms the ALB-to-target-group-to-task path works.
- Confirms the VPC endpoint path supports image pulls and log delivery without NAT Gateway.
- Provides concrete portfolio evidence before resources are destroyed for cost control.

Tradeoff:

- The public ALB endpoint is temporary and will not remain available after cleanup.
- Validation evidence must be documented before running destroy.

## Use an ephemeral lab deployment model

This project will use a deploy-test-destroy workflow.

Infrastructure should be created only when validating the project, then destroyed after testing is complete.

Reasoning:

- The project is intended for hands-on learning and portfolio validation, not ongoing production usage.
- ECS Fargate and Application Load Balancer resources can create recurring cost while running.
- Destroying resources after validation keeps the AWS account clean and cost-controlled.
- Terraform makes it safe to recreate the infrastructure later when needed.

Tradeoff:

- The public endpoint will not remain available after cleanup.
- CloudWatch logs and runtime evidence may be removed unless saved separately.
- Any manual runtime changes would be lost, which reinforces the need to keep configuration in code.

Future production enhancement:

- Use a remote encrypted Terraform backend.
- Keep production state separate from lab/test state.
- Add environment-specific variable files or workspaces only after the base architecture is stable.
