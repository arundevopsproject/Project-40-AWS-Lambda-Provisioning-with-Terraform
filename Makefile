# [ 🐋 DOCKER - PUSH IMAGE TO ECR ]

ECR_NAME      ?= terraform-lambda-tutorial
VERSION       ?= latest
DOCKERFILE    ?= docker/lambda.Dockerfile
AWS_REGION    ?= eu-west-2

ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
ECR_URL    := $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_NAME)
FULL_IMAGE := $(ECR_URL):$(VERSION)

## Builds Docker image and pushes it to ECR
# Example: make docker-lambda-image-push
docker-lambda-image-push:
	aws ecr get-login-password | docker login --username AWS --password-stdin $(ECR_URL)
	docker build -t $(FULL_IMAGE) -f $(DOCKERFILE) .
	docker push $(FULL_IMAGE)

# [ 🧱 TERRAFORM - DEPLOY ECR / LAMBDA ]
# SERVICES: [ ecr, lambda ]

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

