provider "aws" {
  region = var.region
}

# Use an existing VPC by ID
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

# Security group allowing SSH (port 22) and optionally HTTP (port 80)
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

# Launch EC2 instance
resource "aws_instance" "ec2" {
  ami                         = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 LTS in us-east-1
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "Ansible-EC2-Docker"
  }
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}


