# AWS Lambda File Processor

This project showcases a **serverless file processing system using **AWS Lambda**, **S3**, and **API Gateway**, fully provisioned with **Terraform** and deployed via **GitHub Actions**.

## Project Overview

The Lambda File Processor listens for file uploads to an S3 bucket. Once a file is uploaded, it automatically triggers a Lambda function. This function logs the event and returns a simple acknowledgment. An HTTP endpoint is also available via API Gateway to manually test or invoke the function.

---

## Features

- Serverless architecture with AWS Lambda
- File upload triggers from S3 bucket events
- API Gateway integration to trigger Lambda via HTTP
- Infrastructure-as-Code using Terraform
- CI/CD deployment via GitHub Actions
- Written in Python 3.11

---

## Project Structure

├── lambda_function.py # Python Lambda handler
├── lambda_function.zip # Zipped deployment package (ignored in Git)
├── main.tf # Terraform infrastructure definitions
├── variables.tf # Input variables
├── outputs.tf # Outputs including API Gateway URL
├── .github/workflows/lambda-deploy.yml # GitHub Actions pipeline
├── README.md # Project documentation
└── .gitignore

---

## Technologies Used

- AWS Lambda
- Amazon S3
- API Gateway (HTTP API)
- Terraform (v1.8+)
- GitHub Actions
- Python 3.11

---

GitHub Actions Pipeline
On every push to project-3-s3-lambda-clean, this workflow will:

Zip the Lambda function

Authenticate to AWS

Upload new code to the Lambda function