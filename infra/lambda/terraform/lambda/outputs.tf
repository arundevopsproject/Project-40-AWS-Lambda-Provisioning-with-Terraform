output "api_invoke_url" {
  value       = aws_apigatewayv2_api.lambda_api.api_endpoint
  description = "Base URL for the API ($default stage)"
}