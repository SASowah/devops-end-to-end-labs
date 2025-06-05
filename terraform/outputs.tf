output "nodejs_chat_eip" {
    value       = aws_eip.nodejs_chat_eip.public_ip
    description = "The Elastic IP address of the Node.js Chat server"
}

output "jenkins_public_ip" {
    value       = aws_instance.jenkins_server.public_ip
    description = "The public IP address of the Jenkins server"
}
