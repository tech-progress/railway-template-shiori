# Shiori on Railway

Deploy [Shiori](https://github.com/go-shiori/shiori) 1.8.0 as a bookmark manager with generated owner credentials and durable archives. A small Alpine wrapper starts the pinned upstream binary privately, replaces Shiori's documented first-boot credential, then exposes the normal application with bearer-token API support.

## Deploy on Railway

Deploy, copy `SHIORI_USERNAME` and `SHIORI_PASSWORD`, and open the generated domain. The same credentials work in the web UI, browser extensions, and API.

## Required environment variables

No value must be supplied by the deployer. Railway generates the owner password and persistent `SHIORI_HTTP_SECRET_KEY`.

## Persistence and limitations

The 5 GB `/shiori` volume stores SQLite data, readable content, and page archives. One process is suitable for individuals and small teams, not high availability; back up the complete volume before upgrades.
