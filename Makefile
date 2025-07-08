# [ 🐋 DOCKER - PUSH IMAGE TO ECR ]

ECR_NAME      ?= terraform-lambda-tutorial
VERSION       ?= latest
DOCKERFILE    ?= docker/lambda.Dockerfile
AWS_REGION    ?= eu-west-2

ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
ECR_URL    := $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_NAME)
FULL_IMAGE := $(ECR_URL):$(VERSION)

# Builds Docker image and pushes it to ECR
docker-lambda-image-push:
	aws ecr get-login-password | docker login --username AWS --password-stdin $(ECR_URL)
	docker build -t $(FULL_IMAGE) -f $(DOCKERFILE) .
	docker push $(FULL_IMAGE)

# [ 🧱 TERRAFORM - DEPLOY ECR / LAMBDA ]
TERRAFORM_BASE_PATH = infra/lambda/terraform
SERVICE = "ecr" # SERVICE TO DEPLOY (e.g. ecr, lambda)
TERRAFORM_FULL_PATH = $(TERRAFORM_BASE_PATH)/$(SERVICE)

## Init Terraform template
# Example: make terraform-init SERVICE=ecr
terraform-init: 
	terraform -chdir=$(TERRAFORM_FULL_PATH) init

## Validates Terraform template 
# Example: make terraform-validate SERVICE=ecr
terraform-validate: 
	terraform -chdir=$(TERRAFORM_FULL_PATH) validate

## Applies Terraform template
# Example: make terraform-apply SERVICE=ecr
terraform-apply: 
	terraform -chdir=$(TERRAFORM_FULL_PATH) apply

## Destroys Terraform template
# Example: make terraform-destroy SERVICE=ecr
terraform-destroy:
	terraform -chdir=$(TERRAFORM_FULL_PATH) destroy


# # [ 🧱 TERRAFORM - ECR ]
# PATH_TO_TERRAFORM_ECR_TEMPLATE = "infra/lambda/terraform/ecr"

# # Initializes Terraform
# terraform-ecr-init: 
# 	terraform -chdir=$(PATH_TO_TERRAFORM_ECR_TEMPLATE) init

# # Lints Terraform
# terraform-ecr-validate: 
# 	terraform -chdir=$(PATH_TO_TERRAFORM_ECR_TEMPLATE) validate

# # Applies Terraform to create ECR repository
# terraform-ecr-apply: 
# 	terraform -chdir=$(PATH_TO_TERRAFORM_ECR_TEMPLATE) apply

# # Destroys ECR repository
# terraform-ecr-destroy:
# 	terraform -chdir=$(PATH_TO_TERRAFORM_ECR_TEMPLATE) destroy

# # [ 🧱 TERRAFORM - LAMBDA ]
# PATH_TO_TERRAFORM_LAMBDA_TEMPLATE = "infra/lambda/terraform/lambda"

# # Initializes Terraform
# terraform-lambda-init: 
# 	terraform -chdir=$(PATH_TO_TERRAFORM_LAMBDA_TEMPLATE) init

# # Validates Terraform template
# terraform-lambda-validate: 
# 	terraform -chdir=$(PATH_TO_TERRAFORM_LAMBDA_TEMPLATE) validate

# # Applies Terraform to create Lambda & API Gateway
# terraform-lambda-apply: 
# 	terraform -chdir=$(PATH_TO_TERRAFORM_LAMBDA_TEMPLATE) apply

# # Destroys Lambda & API Gateway
# terraform-lambda-destroy:
# 	terraform -chdir=$(PATH_TO_TERRAFORM_LAMBDA_TEMPLATE) destroy


