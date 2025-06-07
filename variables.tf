variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket to trigger Lambda function"
  default     = "lambda-file-upload-bucket-demo"
}
