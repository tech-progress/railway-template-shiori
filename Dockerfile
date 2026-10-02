FROM ghcr.io/go-shiori/shiori:v1.8.0@sha256:d3bdfc1b68b8f267a04cf74d73b8a0e1d99ac71c3a9047375e97202f079eb1f6 AS upstream
FROM alpine:3.23.6@sha256:85fe1e81d6758c208f3e1eed4338a1997e19d4be002d4dd32d3100c9a8c010a0
RUN apk add --no-cache ca-certificates curl
COPY --from=upstream /usr/bin/shiori /usr/bin/shiori
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint
RUN chmod 0755 /usr/local/bin/railway-entrypoint
ENV PORT=8080 SHIORI_DIR=/shiori
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-entrypoint"]
