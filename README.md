# AWS Infrastructure as Code with Terraform

## Project Overview

This project demonstrates a complete AWS infrastructure setup using Terraform, featuring a scalable web application architecture with ECS Fargate, Application Load Balancer, VPC networking, and monitoring capabilities.

## Architecture

The infrastructure creates a production-ready environment with the following components:

### Core Infrastructure
- **VPC** with public and private subnets across 2 availability zones
- **Internet Gateway** for public internet access
- **NAT Gateway** for private subnet internet access
- **Route Tables** for proper traffic routing

### Application Layer
- **ECS Fargate Cluster** for container orchestration
- **ECS Service** running nginx web server
- **Application Load Balancer** for traffic distribution
- **Target Group** with health checks and auto-scaling

### Storage & Monitoring
- **S3 Bucket** with intelligent tiering lifecycle policies
- **CloudWatch Logs** for centralized logging
- **CloudWatch Alarms** for CPU utilization monitoring
- **Auto Scaling** policies for dynamic resource management

## 🚀 Features

- **Multi-AZ Deployment**: High availability across availability zones
- **Auto Scaling**: CPU-based scaling policies (1-4 instances)
- **Security Groups**: Proper network isolation and access control
- **ARM64 Support**: Optional Graviton processor support
- **Lifecycle Management**: S3 storage optimization
- **Monitoring**: Comprehensive logging and alerting

## 📋 Prerequisites

### Required Software
- **Terraform** >= 1.0.0
- **AWS CLI** configured with appropriate credentials
- **Git** for version control

### AWS Requirements
- AWS account with appropriate permissions
- IAM user/role with the following permissions:
  - VPC management
  - ECS service management
  - S3 bucket creation
  - CloudWatch monitoring
  - IAM role creation

### Environment Setup
```bash
# Install Terraform (Windows with Chocolatey)
choco install terraform

# Or download from https://www.terraform.io/downloads.html

# Configure AWS credentials
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and default region
```

## Installation & Usage

### 1. Clone the Repository
```bash
git clone <repository-url>
cd infra-assignment
```

### 2. Configure Variables
Edit `terraform.tfvars` to match your requirements:
```hcl
project_name = "my-project"
env          = "dev"
region       = "us-east-1"
use_arm      = false  # Set to true for ARM64/Graviton
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Plan
```bash
terraform plan -out plan.tfplan
```

### 5. Apply the Infrastructure
```bash
terraform apply "plan.tfplan"
```

### 6. Access Your Application
After successful deployment, get the ALB DNS name:
```bash
terraform output alb_dns
```

## Project Structure

```
infra-assignment/
├── main.tf                 # Root module configuration
├── variables.tf            # Variable definitions
├── terraform.tfvars        # Variable values
├── output.tf               # Output values
├── provider.tf             # AWS provider configuration
├── modules/
│   ├── vpc/               # VPC and networking resources
│   ├── ecs/               # ECS cluster and service
│   ├── s3/                # S3 bucket and lifecycle policies
│   └── cloudwatch/        # Monitoring and alerting
└── README.md              # This file
```

## 🔧 Configuration Options

### VPC Configuration
- **CIDR Block**: 10.0.0.0/16
- **Public Subnets**: 2 subnets across different AZs
- **Private Subnets**: 2 subnets across different AZs
- **NAT Gateway**: Single NAT gateway for cost optimization

### ECS Configuration
- **Launch Type**: Fargate (serverless)
- **CPU**: 256 units (0.25 vCPU)
- **Memory**: 512 MB
- **Container**: nginx:latest
- **Port**: 80 (HTTP)

### Auto Scaling
- **Min Capacity**: 1 instance
- **Max Capacity**: 4 instances
- **Scaling Policy**: CPU utilization > 70%
- **Evaluation Periods**: 2

### S3 Configuration
- **Lifecycle Rule**: Transition to STANDARD_IA after 30 days
- **Versioning**: Disabled by default
- **Encryption**: Server-side encryption enabled

## Monitoring & Logging

### CloudWatch Metrics
- ECS service CPU utilization
- ECS service memory utilization
- ALB request count and latency

### CloudWatch Alarms
- **CPU High**: Triggers when average CPU > 70%
- **Alarm Actions**: Currently empty (can be configured for SNS notifications)

### Log Groups
- **ECS Logs**: `/ecs/{project-name}` with 14-day retention
- **ALB Logs**: Can be enabled for detailed access logging

## Troubleshooting

### Common Issues

#### Resource Already Exists
If you encounter "Resource already exists" errors:
```bash
# Option 1: Destroy and recreate (clean slate)
terraform destroy -auto-approve
terraform apply

# Option 2: Import existing resources
terraform import module.ecs.aws_iam_role.ecs_task_exec <role-name>
```

#### VPC Dependency Issues
If you see count-related errors:
- Ensure all modules are properly referenced
- Check that security group IDs are correctly passed

#### ECS Service Issues
- Verify target group `target_type` is set to "ip" for Fargate
- Check security group rules allow traffic between ALB and ECS
- Ensure private subnets have NAT gateway access

### Debug Commands
```bash
# Check Terraform state
terraform show

# Validate configuration
terraform validate

# Format code
terraform fmt

# Check plan without applying
terraform plan
```

## Security Considerations

### Network Security
- Public subnets only contain ALB and NAT Gateway
- ECS tasks run in private subnets
- Security groups restrict traffic appropriately
- No direct internet access for ECS tasks

### IAM Security
- ECS tasks use minimal required permissions
- Execution role follows least privilege principle
- No hardcoded credentials in code

### Data Security
- S3 bucket encryption enabled by default
- VPC endpoints can be added for private S3 access
- CloudTrail can be enabled for audit logging

## Cost Optimization

### Current Optimizations
- Single NAT Gateway (vs. one per AZ)
- S3 lifecycle policies for storage tiering
- Fargate spot instances can be enabled
- CloudWatch log retention limited to 14 days

### Additional Cost Savings
- Enable Fargate spot instances for non-critical workloads
- Implement S3 Intelligent Tiering
- Use CloudWatch Contributor Insights
- Consider Savings Plans for long-term commitments

## Scaling & Performance

### Horizontal Scaling
- Auto-scaling based on CPU utilization
- Load balancer distributes traffic
- Multi-AZ deployment for high availability

### Vertical Scaling
- Adjust CPU and memory in ECS task definition
- Modify auto-scaling thresholds
- Tune health check parameters

## Future Enhancements

### Planned Features
- [ ] HTTPS/SSL termination
- [ ] WAF integration for security
- [ ] Route 53 DNS management
- [ ] Backup and disaster recovery
- [ ] CI/CD pipeline integration

### Monitoring Improvements
- [ ] Custom CloudWatch dashboards
- [ ] SNS notifications for alarms
- [ ] X-Ray tracing integration
- [ ] Enhanced logging and metrics

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Useful Links

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Note**: This infrastructure is designed for development and testing environments. For production use, additional security measures, monitoring, and compliance configurations should be implemented.