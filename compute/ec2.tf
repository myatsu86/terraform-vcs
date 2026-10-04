# VPC and subnets shared from the AWS_Networking workspace
data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "hello-cloud-learning"
    workspaces = {
      name = "AWS_Networking"
    }
  }
}

locals {
  vpc_id           = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_id = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
}

# Latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Security group allowing all inbound traffic (all ports, all protocols)
resource "aws_security_group" "allow_all" {
  name        = "${var.project_name}-ec2-allow-all"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "All inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["180.129.82.208/32"]
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

resource "aws_instance" "main" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = local.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-ec2-1"
  }
}
