provider "aws" {
  region = var.aws_region
}

# Security Group (shared by both EC2s)
resource "aws_security_group" "nodejs_chat_sg" {
  name        = "nodejs_chat_sg"
  description = "Allow SSH and HTTP"

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
}

# Node.js Chat EC2
resource "aws_instance" "nodejs_chat_ec2" {
  ami                    = "ami-084568db4383264d4" # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.nodejs_chat_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "nodejs-chat-ec2"
  }
}

# Jenkins EC2
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-084568db4383264d4" # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and Jenkins Web UI"

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
