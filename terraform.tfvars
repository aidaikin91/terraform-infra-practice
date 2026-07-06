aws_region          = "us-east-1"
project_name        = "terraform-infra-practice"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
instance_type       = "t2.micro"
instance_count      = 2
enable_https        = false
domain_name         = ""
