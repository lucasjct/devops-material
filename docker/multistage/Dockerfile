FROM golang AS app-go

ADD app.go /src
WORKDIR /src
RUN go build -o app.go .

FROM alpine

WORKDIR /app
COPY --from=app-go /src/app /app
ENTRYPOINT ./app