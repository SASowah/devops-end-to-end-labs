# Using local state storage
# If you need remote state in the future, uncomment and configure the S3 backend below
# terraform {
#   backend "s3" {
#     bucket         = "ecommerce-terraform-state"
#     key            = "eks/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-lock"
#   }
# }