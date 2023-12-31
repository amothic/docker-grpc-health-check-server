# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:1.20-alpine AS build

WORKDIR /workdir

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./

RUN go build -o /server

##
## Deploy
##
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /server /server

EXPOSE 9090

USER nonroot:nonroot

ENTRYPOINT ["/server"]
CMD [ "/server" ]
