output "nodejs_chat_public_ip" {
  value = aws_instance.nodejs_chat_ec2.public_ip
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
