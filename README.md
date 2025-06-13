# Project 1: Java E-Commerce Backend (Spring Boot + Docker + Jenkins + EKS)

## Overview
This project showcases a fully containerized Java (Spring Boot) REST API deployed on an AWS EKS (Elastic Kubernetes Service) cluster with an automated CI/CD pipeline using Jenkins. Monitoring and observability are integrated using Prometheus and Grafana.

##  Architecture & Stack
- **Java Spring Boot** REST API
- **Docker** for containerization
- **Jenkins** for CI/CD automation
- **Terraform** to provision EKS and supporting AWS resources
- **AWS EKS** as Kubernetes infrastructure
- **ALB Ingress Controller** for app exposure
- **Prometheus + Grafana** for observability and monitoring

##  Project Structure
devops-end-to-end-labs/
├── terraform/
│ └── eks/ # EKS cluster, IAM, ALB Ingress resources
├── kubernetes/
│ ├── deployment.yaml # K8s deployment for ecommerce-backend
│ ├── service.yaml # K8s ClusterIP service
│ ├── ingress.yaml # ALB Ingress for external access
│ └── monitoring.yaml # HelmChart-based monitoring setup
├── Dockerfile # Multi-stage Docker build
├── Jenkinsfile # CI/CD pipeline
├── pom.xml # Spring Boot config
└── src/ # Java source code

##  CI/CD Pipeline with Jenkins
1. **Checkout** from GitHub (`development` branch)
2. **Build & Test** the Spring Boot app using Maven
3. **Build Docker Image** and push to Docker Hub (`samsow/ecommerce-backend`)
4. **Deploy to EKS** using `kubectl` with Terraform-managed `kubeconfig`
5. **Expose the app** via ALB Ingress
6. **Monitor the app** using Prometheus and Grafana


- **Prometheus** scrapes metrics from app containers
- **Grafana** visualizes cluster and app-level metrics
- Accessible via a LoadBalancer service
- Datasource configured automatically for Prometheus

##  Access
- **Application**: `http://<ALB_DNS>` → Displays a welcome page
- **Grafana**: `http://<Grafana_LoadBalancer_DNS>`  

