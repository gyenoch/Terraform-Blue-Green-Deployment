data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["blue-green-vpc"]
  }
}

data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["blue-green-sub-1"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["blue-green-sub-2"]
  }
}

data "aws_lb" "app_lb" {
  name = var.lb_name
}

data "aws_security_group" "app_sg" {
  name = var.sg_name
}

