# Terraform Infrastructure Practice

A learning project that provisions a basic web application infrastructure on AWS using Terraform.

## Architecture

```
Internet → HTTP (80) → 301 redirect → HTTPS (443) → ALB → EC2 instances (Apache)
                                                      ↕
                                              Public Subnet 1 (us-east-1a)
                                              Public Subnet 2 (us-east-1b)
                                                      ↕
                                              VPC (10.0.0.0/16)
```

## Resources Created

| Resource | Description |
|---|---|
| **VPC** | Custom VPC with DNS support |
| **Subnets** | 2 public subnets across availability zones |
| **Internet Gateway** | Internet access for public subnets |
| **Route Table** | Public route table with internet gateway route |
| **ALB** | Application Load Balancer with HTTP → HTTPS redirect |
| **ACM Certificate** | SSL/TLS certificate with Route 53 DNS validation |
| **Route 53 Record** | A record pointing domain to ALB |
| **EC2 Instances** | 2x Amazon Linux 2023 (t2.micro) running Apache |
| **Security Groups** | ALB (HTTP/HTTPS inbound), EC2 (HTTP from ALB, SSH) |
| **Key Pair** | RSA 4096-bit SSH key pair |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- AWS CLI configured with valid credentials
- A domain name managed in Route 53
- An S3 bucket for remote state (`terraform-infra-practice-state`)

## Setup

1. **Create the S3 bucket for remote state:**
   ```bash
   aws s3 mb s3://terraform-infra-practice-state --region us-east-1
   ```

2. **Update `terraform.tfvars`** with your domain name:
   ```hcl
   domain_name = "yourdomain.com"
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
| `domain_name` | Domain for ACM certificate | — (required) |

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
| `website_url` | HTTPS URL for the web app |

## SSH Access

After `terraform apply`, connect to an instance:
```bash
ssh -i terraform-infra-practice-key.pem ec2-user@<instance-public-ip>
```

## Cleanup

```bash
terraform destroy
```
