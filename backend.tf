terraform {
  backend "s3" {
    bucket = "terraform-infra-practice-state"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
