FROM golang:1.21

WORKDIR /app

# Download modules
COPY src/go.* ./
RUN go mod download

COPY src/*.go ./

# Build
RUN go build

# Run
CMD ["/app/test"]
