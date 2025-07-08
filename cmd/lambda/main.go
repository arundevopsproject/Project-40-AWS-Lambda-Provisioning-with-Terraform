package main

import (
	"terraform-lambda-tutorial/internal/lambda"

	AWSLambda "github.com/aws/aws-lambda-go/lambda"
)

func main() {
	AWSLambda.Start(lambda.LambdaHandler)
}
