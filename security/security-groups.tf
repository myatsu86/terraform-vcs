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

# Dashboard instance: port 8000 and SSH (22) from my IP only
resource "aws_security_group" "dashboard" {
  name        = "${var.project_name}-dashboard"
  description = "Dashboard EC2: 8000 and 22 from my IP"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "${var.project_name}-dashboard"
  }
}

resource "aws_vpc_security_group_ingress_rule" "dashboard_8000" {
  security_group_id = aws_security_group.dashboard.id
  description       = "Dashboard port 8000 from my IP"
  cidr_ipv4         = var.my_ip_cidr
  ip_protocol       = "tcp"
  from_port         = 8000
  to_port           = 8000
}

resource "aws_vpc_security_group_ingress_rule" "dashboard_ssh" {
  security_group_id = aws_security_group.dashboard.id
  description       = "SSH from my IP"
  cidr_ipv4         = var.my_ip_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "dashboard_all" {
  security_group_id = aws_security_group.dashboard.id
  description       = "All outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Counting instance: port 9000 from the dashboard security group only
resource "aws_security_group" "counting" {
  name        = "${var.project_name}-counting"
  description = "Counting EC2: 9000 from dashboard only"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "${var.project_name}-counting"
  }
}

resource "aws_vpc_security_group_ingress_rule" "counting_9000" {
  security_group_id            = aws_security_group.counting.id
  description                  = "Counting port 9000 from dashboard"
  referenced_security_group_id = aws_security_group.dashboard.id
  ip_protocol                  = "tcp"
  from_port                    = 9000
  to_port                      = 9000
}

resource "aws_vpc_security_group_egress_rule" "counting_all" {
  security_group_id = aws_security_group.counting.id
  description       = "All outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
