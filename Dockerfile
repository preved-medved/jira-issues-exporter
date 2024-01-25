###################### Test ######################
FROM golangci/golangci-lint:v1.51.1 as test
WORKDIR /build
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

COPY go.* ./
COPY vendor/ ./vendor
COPY main.go ./main.go

RUN go env && go version
RUN echo "  ## Test" && go test -v -count=1 -race -failfast -timeout 300s ./...
RUN echo "  ## Lint" && golangci-lint run -v --deadline=300s ./...

###################### Build ######################
FROM golang:1.21.6-alpine3.18 as build
WORKDIR /build
ENV \
    TERM=xterm-color \
    TIME_ZONE="UTC" \
    GOOS=linux \
    CGO_ENABLED=0 \
    GOFLAGS="-mod=vendor"

COPY go.* ./
COPY vendor/ ./vendor
COPY main.go ./main.go
RUN echo "  ## Build" && go build -o /app . && echo "  ## Done"

###################### Release ######################
FROM alpine:3.15
COPY --from=build /app /app
USER nobody:nobody
CMD ["/app"]