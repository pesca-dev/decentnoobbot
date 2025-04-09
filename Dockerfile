FROM rust:1.86-alpine3.20 AS builder

WORKDIR /work

COPY . .

RUN apk update
RUN apk add pkgconfig libressl-dev gcc g++ libc-dev make 

RUN cargo build --release
RUN apk add --no-cache ca-certificates

########################################
########################################
########################################

FROM alpine:3.18.3 AS app
LABEL org.opencontainers.image.source="https://github.com/pesca-dev/decentnoobbot"

USER 10001

WORKDIR /app

COPY --chown=10001:10001 --from=builder /work/target/release/decentnoobbot .
COPY --chown=10001:10001 --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# must match your final server executable name
ENTRYPOINT ["/app/decentnoobbot"]
