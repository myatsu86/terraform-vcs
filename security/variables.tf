variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Project name, used as a prefix for resource names"
  type        = string
  default     = "tf-vcs-singapore"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_profile" {
  description = "AWS CLI profile for local runs (leave null on HCP Terraform, which uses workspace credentials)"
  type        = string
  default     = null
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR form (e.g. 203.0.113.10/32), allowed to reach the dashboard instance"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0)) && var.my_ip_cidr != "0.0.0.0/0"
    error_message = "my_ip_cidr must be a valid CIDR and must not be 0.0.0.0/0."
  }
}
