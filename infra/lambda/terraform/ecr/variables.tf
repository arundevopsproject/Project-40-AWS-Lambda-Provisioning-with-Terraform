variable "region" {
    description = "AWS Region"
    type        = string
    default     = "eu-west-2"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "terraform-lambda-tutorial"
}
