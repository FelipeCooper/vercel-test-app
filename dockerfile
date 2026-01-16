# syntax=docker/dockerfile:1
# --- Build Stage ---
# Use the official Go image for building
FROM golang:1.22-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to leverage Docker's build cache
COPY go.mod go.sum ./

# Download Go module dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application binary
# CGO_ENABLED=0 disables CGo, producing a statically linked binary
RUN CGO_ENABLED=0 go build -o /myapp .

# --- Run Stage ---
# Start a new, minimal image from scratch or alpine
FROM alpine:latest AS run
# Use scratch for the absolute smallest image, if no dependencies like SSL certs are needed
# FROM scratch AS run 

# Set working directory to root
WORKDIR /

# Copy the compiled binary from the 'build' stage
COPY --from=build /myapp /myapp

# Expose the port your application listens on (e.g., 8080)
EXPOSE 8080

# Command to run the executable when the container starts
CMD ["/myapp"]
