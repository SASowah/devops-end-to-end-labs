provider "aws" {
  region = var.aws_region
}

# Security Group for Node.js Chat App
resource "aws_security_group" "nodejs_chat_sg" {
  name        = "nodejs_chat_sg"
  description = "Allow SSH, HTTP, and HTTPS access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nodejs_chat_sg"
  }
}

# EC2 Instance for Node.js Chat App (without associate_public_ip)
resource "aws_instance" "nodejs_chat_ec2" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.nodejs_chat_sg.id]

  tags = {
    Name = "nodejs-chat-ec2"
  }
}

# Elastic IP (not directly tied to instance)
resource "aws_eip" "nodejs_chat_eip" {
  domain = "vpc"

  tags = {
    Name = "nodejs-chat-eip"
  }
}

# Associate EIP with EC2
resource "aws_eip_association" "nodejs_chat_eip_assoc" {
  instance_id   = aws_instance.nodejs_chat_ec2.id
  allocation_id = aws_eip.nodejs_chat_eip.id
}

# Jenkins Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and Jenkins UI access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true # OK here if not using EIP

  tags = {
    Name = "jenkins-server"
  }
}
