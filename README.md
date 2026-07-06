# Terraform Infrastructure Practice

A learning project that provisions a basic web application infrastructure on AWS using Terraform.

## Architecture

**HTTP only (default):**
```
Internet → HTTP (80) → ALB → EC2 instances (Apache)
                        ↕
                Public Subnet 1 (us-east-1a)
                Public Subnet 2 (us-east-1b)
                        ↕
                VPC (10.0.0.0/16)
```

**With HTTPS enabled (`enable_https = true`):**
```
Internet → HTTP (80) → 301 redirect → HTTPS (443) → ALB → EC2 instances (Apache)
```

## Resources Created

| Resource | Description |
|---|---|
| **VPC** | Custom VPC with DNS support |
| **Subnets** | 2 public subnets across availability zones |
| **Internet Gateway** | Internet access for public subnets |
| **Route Table** | Public route table with internet gateway route |
| **ALB** | Application Load Balancer (HTTP, or HTTP→HTTPS redirect when HTTPS enabled) |
| **EC2 Instances** | 2x Amazon Linux 2023 (t2.micro) running Apache |
| **Security Groups** | ALB (HTTP inbound, HTTPS when enabled), EC2 (HTTP from ALB, SSH) |
| **Key Pair** | RSA 4096-bit SSH key pair |

When `enable_https = true`, these additional resources are created:

| Resource | Description |
|---|---|
| **ACM Certificate** | SSL/TLS certificate with Route 53 DNS validation |
| **Route 53 Records** | Certificate validation + A record pointing domain to ALB |
| **HTTPS Listener** | ALB listener on port 443 with TLS 1.3 |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- AWS CLI configured with valid credentials
- An S3 bucket for remote state (`terraform-infra-practice-state`)
- (Optional) A domain name managed in Route 53 — required only if enabling HTTPS

## Setup

1. **Create the S3 bucket for remote state:**
   ```bash
   aws s3 mb s3://terraform-infra-practice-state --region us-east-1
   ```

2. **Update `terraform.tfvars`** as needed. To enable HTTPS:
   ```hcl
   enable_https = true
   domain_name  = "yourdomain.com"
   ```

3. **Initialize, plan, and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Variables

| Variable | Description | Default |
|---|---|---|
| `aws_region` | AWS region | `us-east-1` |
| `project_name` | Name prefix for resources | `terraform-infra-practice` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `public_subnet_cidrs` | Public subnet CIDRs | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `instance_type` | EC2 instance type | `t2.micro` |
| `instance_count` | Number of EC2 instances | `2` |
| `enable_https` | Enable HTTPS with ACM + Route 53 | `false` |
| `domain_name` | Domain for ACM certificate | `""` |

## Outputs

| Output | Description |
|---|---|
| `vpc_id` | VPC ID |
| `public_subnet_ids` | Public subnet IDs |
| `alb_dns_name` | ALB DNS name |
| `ec2_instance_ids` | EC2 instance IDs |
| `ec2_public_ips` | EC2 public IPs |
| `private_key_file` | Path to SSH private key |
| `ssh_command` | Example SSH command |
| `website_url` | HTTP or HTTPS URL depending on config |

## SSH Access

After `terraform apply`, connect to an instance:
```bash
ssh -i terraform-infra-practice-key.pem ec2-user@<instance-public-ip>
```

## Cleanup

```bash
terraform destroy
aws s3 rb s3://terraform-infra-practice-state --force
```
