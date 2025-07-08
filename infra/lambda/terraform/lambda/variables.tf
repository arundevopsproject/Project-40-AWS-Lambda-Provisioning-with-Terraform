variable "region" {
    description = "AWS Region"
    type        = string
    default     = "eu-west-2"
}

variable "repository_name" {
  description = "ECR repository that holds the image"
  type        = string
  default     = "terraform-lambda-tutorial"
}

variable "image_tag" {
  description = "Tag of the ECR image to deploy"
  type        = string
  default     = "latest"
}

variable "lambda_function_name" {
  description = "Name for the Lambda function"
  type        = string
  default     = "terraform-lambda-tutorial"
}