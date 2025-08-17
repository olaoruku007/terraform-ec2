provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = "${var.Environment}-terraform-pro-vpc"
      Environment = var.Environment
      ManagedBy   = "Terraform"
    }
  }

}
