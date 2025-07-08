FROM golang:latest AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o lambda ./cmd/lambda

FROM public.ecr.aws/lambda/provided:al2023
COPY --from=builder /app/lambda .
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie
RUN chmod +x /usr/local/bin/aws-lambda-rie
ENTRYPOINT ["/usr/local/bin/aws-lambda-rie", "./lambda"]