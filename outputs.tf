output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "alb_dns_name" {
  description = "DNS name of the ALB — use this to access the web app"
  value       = aws_lb.main.dns_name
}

output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.web[*].id
}

output "ec2_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.web[*].public_ip
}

output "private_key_file" {
  description = "Path to the SSH private key file"
  value       = local_file.private_key.filename
}

output "ssh_command" {
  description = "Example SSH command to connect to the first instance"
  value       = "ssh -i ${local_file.private_key.filename} ec2-user@${aws_instance.web[0].public_ip}"
}

output "website_url" {
  description = "HTTPS URL for the web app"
  value       = "https://${var.domain_name}"
}
