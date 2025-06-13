terraform {
  backend "s3" {
    bucket         = "sasowah-devops-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "devops-tf-locks"  # Ensure this matches the DynamoDB table name in your backend-bootstrap
    encrypt = true
  }
}
