# 📦 Terraform-AWS-Lambda Tutorial

This repository contains Terraform code to deploy a Golang AWS Lambda function, triggered by API Gateway. The Lambda is packaged as a Docker image and stored in AWS Elastic Container Registry (ECR). You can also test the Lambda locally using the AWS Lambda Runtime Emulator, allowing HTTP-based invocation during development.

## 🧬 Architecture

This project uses Terraform to deploy a simple AWS Lambda function, triggered by an HTTP POST request to the `/greetings` endpoint via API Gateway. The request body should include a `name` (e.g., `{ "name": "George" }`), and the Lambda will respond with a personalized greeting.

The diagram below shows the overall architecture:

<ADD_IMAGE_HERE>

## 🔨 Lambda Development

Before deploying, we need to build our Lambda function. This project defines a simple Lambda that reads a `name` from the request body and returns a personalized greeting.

📁 Code Location: `internal/lambda/lambda.go`

---

#### 🧪 Local Testing with Docker

To test the Lambda locally, we use the `aws-lambda-runtime-interface-emulator` to mimic the AWS Lambda runtime in Docker.

🔗 Link to [AWS Lambda Runtime Emulator]("https://github.com/aws/aws-lambda-runtime-interface-emulator")

The local test Dockerfile is located at:  
`internal/lambda/dev/lambda.Dockerfile`

To build and run the local test container, use:

```bash
docker compose up --build
```

This starts the Lambda locally and exposes an **endpoint** for invocation:

**POST** `http://localhost:8080/2015-03-31/functions/function/invocations`

**_Body:_**

```json
{
  "body": "{\"name\":\"George\"}"
}
```

**_NOTE:_** This exact body is required to mimic the request body sent by API Gateway.

**_Expected Response:_**

```json
{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json"
  },
  "multiValueHeaders": null,
  "body": "{\"message\":\"Hello George\"}"
}
```

You will see that the response body will contain our greeting (e.g. `Hello George`)

### 🐋 Dockerizing the Lambda for AWS

For deployment, we no longer need the emulator used during local testing. Instead, we build a production-ready Docker image for AWS Lambda using:

📁 `docker/lambda.Dockerfile`

To store this image, we use Terraform to provision an AWS Elastic Container Registry (ECR), which will hold our Lambda Docker images.

### 🖼 Pushing Docker Image to ECR

Once the Lambda has been Dockerized, we can push the image to AWS ECR using a Makefile command:

```bash
make docker-lambda-image-push
```

⚠️ Make sure:

- Your AWS credentials are configured (`aws configure`)
- ECR is already created via Terraform

This command pushes the image with the `latest` tag.

✅ Tip: For production, use versioned tags (e.g. `v1.0.3`)

## 📦 Terraform

We use Terraform for two tasks:

1. Provision an AWS Elastic Container Registry (ECR) for the Lambda Docker image (`SERVICE=ecr`)

2. Deploy the API Gateway + Lambda stack (`SERVICE=lambda`)

Our Terraform templates are split into three main files:

- **`main.tf`** – core AWS resources (ECR, API Gateway, Lambda)
- **`variables.tf`** – input variables (names, tags, etc.)
- **`outputs.tf`** – URLs/ARNs printed after deployment

Additionally, to keep things simple we have cli commands found in our `Makefile`:

- **`make terraform-init`** – initialise Terraform
- **`make terraform-validate`** – validate the configuration
- **`make terraform-apply`** – deploy to AWS
- **`make terraform-destroy`** – tear everything down

📝 **_NOTE:_** Use the `SERVICE` keyword to specify which Terraform template to run.  
 Example:

```bash
 make terraform-apply SERVICE=lambda
```

#### 🍱 Deploying an Elastic Container Registry (ECR)

`SERVICE=ecr`

**`make terraform-init SERVICE=ecr`** - Initialise the Terraform template

**`make terraform-apply SERVICE=ecr`** - Apply the Terraform template

This will create a new **ECR** called **_terraform-lambda-tutorial_** (name found in our `variables.tf`)

#### 💨 Deploying API Gateway + Lambda stack

`SERVICE=lambda`

**`make terraform-init SERVICE=ecr`** - Initialise the Terraform template

**`make terraform-apply SERVICE=ecr`** - Apply the Terraform template

This will create our API Gateway with a **POST** endpoint exposed at `/greetings`. And a Lambda function that uses the latest **Docker** image from our **ECR**.

⚠️ **_Important:_**  
This setup is for **tutorial purposes only** to help you get familiar with Terraform.  
The deployed API does not include any **authentication** or **authorization**.
