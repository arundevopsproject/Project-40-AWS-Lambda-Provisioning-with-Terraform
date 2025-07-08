package lambda

type EventBody struct {
	Name string `json:"name" binding:"required"`
}

type ResponseBody struct {
	Message string `json:"message"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}
