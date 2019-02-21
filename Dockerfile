FROM golang:1.10 as build

WORKDIR /go/src/github.com/alexellis/inlets

COPY vendor             vendor
COPY pkg                pkg
COPY main.go            .
COPY parse_upstream.go  .

RUN CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags "-s -w" -o /usr/bin/inlets

FROM alpine:3.9
RUN apk add --force-refresh ca-certificates

COPY --from=build /usr/bin/inlets /root/

EXPOSE 8090

WORKDIR /root/

CMD ["/usr/bin/inlets", "-server=true", "-port=8090"]
