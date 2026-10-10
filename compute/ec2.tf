# Subnets shared from the AWS_Networking workspace
data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "hello-cloud-learning"
    workspaces = {
      name = "AWS_Networking"
    }
  }
}

# Security group shared from the AWS_Security workspace
data "terraform_remote_state" "security" {
  backend = "remote"

  config = {
    organization = "hello-cloud-learning"
    workspaces = {
      name = "AWS_Security"
    }
  }
}

locals {
  security_group_id = data.terraform_remote_state.security.outputs.allow_all_security_group_id
  private_subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
}

# Ubuntu 26.04 (Canonical)
data "aws_ami" "ubuntu" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-20260604"]
  }
}

resource "aws_instance" "counting" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = local.private_subnet_id
  vpc_security_group_ids      = [local.security_group_id]
  associate_public_ip_address = false

  user_data                   = file("${path.module}/../scripts/counting-service.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "${var.project_name}-counting"
  }
}

resource "aws_instance" "dashboard" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  vpc_security_group_ids      = [local.security_group_id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/../scripts/dashboard-service.sh", {
    counting_private_ip = aws_instance.counting.private_ip
  })
  user_data_replace_on_change = true

  tags = {
    Name = "${var.project_name}-dashboard"
  }
}
