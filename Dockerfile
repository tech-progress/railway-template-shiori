FROM ghcr.io/go-shiori/shiori:v1.8.0@sha256:d3bdfc1b68b8f267a04cf74d73b8a0e1d99ac71c3a9047375e97202f079eb1f6 AS upstream
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
RUN apk add --no-cache ca-certificates curl
COPY --from=upstream /usr/bin/shiori /usr/bin/shiori
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint
RUN chmod 0755 /usr/local/bin/railway-entrypoint
ENV PORT=8080 SHIORI_DIR=/shiori
VOLUME /shiori
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-entrypoint"]
