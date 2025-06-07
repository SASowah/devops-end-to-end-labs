# Define the AWS provider and specify the region from variables
provider "aws" {
  region = var.aws_region
}

# Create an S3 bucket for file uploads
# force_destroy allows the bucket to be deleted even if it contains objects
resource "aws_s3_bucket" "upload_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

# Create an IAM role for the Lambda function
# This role allows Lambda to assume it and execute code
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  # Trust policy that allows Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach the basic Lambda execution policy to the role
# This grants permissions for CloudWatch logs
resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create the Lambda function that will process files
resource "aws_lambda_function" "file_processor" {
  function_name = "file_processor_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"  # Entry point in the code
  runtime       = "python3.11"                      # Python version
  timeout       = 10                                # Function timeout in seconds

  # Path to the deployment package (ZIP file containing code)
  filename         = "${path.module}/lambda_function.zip"
  # Hash of the source code to detect changes
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  # Environment variables available to the Lambda function
  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.upload_bucket.bucket
    }
  }
}

# Configure S3 to trigger the Lambda function when new objects are created
resource "aws_s3_bucket_notification" "s3_to_lambda" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    events = ["s3:ObjectCreated:*"]  # Trigger on all object creation events
    lambda_function_arn = aws_lambda_function.file_processor.arn
  }

  # Ensure the Lambda permission is created before this notification
  depends_on = [aws_lambda_permission.allow_s3]
}

# Grant S3 permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "s3.amazonaws.com"  # S3 service
  source_arn    = aws_s3_bucket.upload_bucket.arn  # Only this specific bucket
}

# Create an HTTP API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "file-processor-api"
  protocol_type = "HTTP"  # Using HTTP API (newer, simpler than REST API)
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"  # All methods, all paths
}

# Create an integration between API Gateway and Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"  # Lambda proxy integration
  integration_uri  = aws_lambda_function.file_processor.invoke_arn
  integration_method = "POST"  # Lambda always invoked via POST
  payload_format_version = "2.0"  # HTTP API format
}

# Define a route in API Gateway
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /file"  # Accepts any HTTP method on the /file path
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Create a default stage for the API
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"  # Default stage
  auto_deploy = true  # Automatically deploy changes
}