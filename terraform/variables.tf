variable "aws_region" {
  default = "us-east-1"
}

variable "instance_key_name" {
  description = "Name of existing EC2 key pair"
  default     = "devkey"
}
