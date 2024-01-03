FROM golang:1.21

WORKDIR /app

# Download modules
COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

# Build
RUN go build

# Run
CMD ["/app/test"]
