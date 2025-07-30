provider "aws" {
  region = var.region
}

# Use the existing VPC by ID
data "aws_vpc" "default" {
  id = "vpc-067449f8314d4e6c0"
}

# Find the default subnet within that VPC
data "aws_subnet" "default" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = ["vpc-067449f8314d4e6c0"]
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 LTS in us-east-1
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.ssh_http.id]
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "Ansible-EC2-Docker"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
