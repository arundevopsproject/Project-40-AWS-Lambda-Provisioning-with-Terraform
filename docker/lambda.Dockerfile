FROM golang:latest AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/lambda

FROM public.ecr.aws/lambda/provided:al2023
COPY --from=builder /app/main ./main
ENTRYPOINT [ "./main" ]