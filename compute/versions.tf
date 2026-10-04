terraform {
  cloud {
    organization = "hello-cloud-learning"

    workspaces {
      name = "AWS_Compute"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  # Local runs use the aws-master-admin profile; on HCP Terraform set
  # aws_profile = null (default) and supply AWS_* credentials in the workspace.
  profile = var.aws_profile
  region  = var.region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }
}
