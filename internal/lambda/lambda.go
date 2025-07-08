package lambda

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
)

func LambdaHandler(ctx context.Context, event events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// PARSE EVENT BODY
	var eventBody EventBody
	err := json.Unmarshal([]byte(event.Body), &eventBody)
	if err != nil {
		slog.Error(fmt.Sprintf("🚨 Invalid request body: %s", err.Error()))

		// ERROR MESSAGE
		resp, _ := json.Marshal(ErrorResponse{
			Error: "Invalid request body",
		})

		// RETURN ERROR
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Headers:    map[string]string{"Content-Type": "application/json"},
			Body:       string(resp),
		}, nil
	}

	// CREATE RESPONSE
	name := eventBody.Name
	message := "Hello " + name

	// CREATE RESPONSE BODY
	resp, _ := json.Marshal(ResponseBody{
		Message: message,
	})

	// RETURN RESPONSE
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers:    map[string]string{"Content-Type": "application/json"},
		Body:       string(resp),
	}, nil
}
