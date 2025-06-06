# Node.js Real-Time Chat App (DevOps Project)

This project showcases an end-to-end DevOps pipeline that provisions cloud infrastructure using Terraform, configures the environment with Ansible, and automates deployments through Jenkins. The deployed application is a real-time chat app built with Node.js and Socket.IO.

## Tools & Technologies
- **Terraform** – for infrastructure provisioning (EC2, Elastic IP, Security Groups)
- **Ansible** – for server configuration and app deployment
- **Jenkins** – for CI/CD pipeline automation
- **AWS EC2** – hosts both the Jenkins server and Node.js chat server
- **Nginx** – used as a reverse proxy for the chat app
- **GitHub** – source repository triggering Jenkins builds

## Setup Overview

### Terraform
- Provisions:
  - 1 EC2 instance for Jenkins
  - 1 EC2 instance for Node.js app
  - Elastic IP for persistent access
  - Security groups (ports 22, 80, 443, 8080)

### Ansible
- Installs Node.js, Git, Nginx
- Deploys your custom chat app from GitHub
- Configures systemd service and reverse proxy

### Jenkins
- Pulls the repo from GitHub on push
- Executes Ansible playbook via ssh-agent
- Displays final IP in post-deployment log

## Live App (via Elastic IP)
Visit: `http://<your-elastic-ip>`  

## Project Structure

```
├── ansible/
│   └── roles/
│       └── nodejs_chat/
│           ├── files/
│           ├── handlers/
│           ├── tasks/
│           └── templates/
├── terraform/
├── Jenkinsfile
├── README.md
```
