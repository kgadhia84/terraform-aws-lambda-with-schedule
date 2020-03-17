output "lambda_arn" {
  value = aws_lambda_function.lambda_function.arn
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function"
}

output "qualified_arn" {
  value = aws_lambda_function.lambda_function.qualified_arn
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true)."
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_function.invoke_arn
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
}
