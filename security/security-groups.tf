# VPC shared from the AWS_Networking workspace
data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "hello-cloud-learning"
    workspaces = {
      name = "AWS_Networking"
    }
  }
}

# Security group allowing all inbound traffic (all ports, all protocols)
resource "aws_security_group" "allow_all" {
  name        = "${var.project_name}-ec2-allow-all"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "All inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-allow-all"
  }
}
