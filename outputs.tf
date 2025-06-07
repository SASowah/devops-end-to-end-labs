output "s3_bucket_name" {
  value = aws_s3_bucket.upload_bucket.id
}

output "lambda_function_name" {
  value = aws_lambda_function.file_processor.function_name
}


output "api_gateway_url" {
  description = "Public URL to trigger Lambda via API Gateway"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/file"
}
