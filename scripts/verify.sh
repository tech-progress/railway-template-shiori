#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for file in .railway/railway.ts Dockerfile railway-entrypoint.sh CHANGELOG.md FINDINGS.md LICENSE_REVIEW.md MARKETPLACE.md PUBLISHING.md README.md SUPPORT.md UPGRADE.md VERSION compose.yaml package.json template-defaults.json template-descriptions.json template-networking.json template-volumes.json scripts/audit-template.sh scripts/check-standalone.sh scripts/restore-template-draft.sh scripts/smoke.sh; do test -f "${root}/${file}"; done
version="$(<"${root}/VERSION")"; [[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; for file in "${root}"/template-*.json; do jq empty "${file}"; done; for file in "${root}"/scripts/*.sh; do bash -n "${file}"; done; sh -n "${root}/railway-entrypoint.sh"
SHIORI_PASSWORD=verify docker compose -f "${root}/compose.yaml" config --quiet
grep -Eq "^## ${version//./\\.} - [0-9]{4}-[0-9]{2}-[0-9]{2}$" "${root}/CHANGELOG.md"
for file in README.md PUBLISHING.md; do grep -Fq "current template release is \`v${version}\`" "${root}/${file}"; done
grep -Fq '== "tech-progress/railway-template-shiori"' "${root}/scripts/audit-template.sh"
grep -Fq '== release-v1' "${root}/scripts/audit-template.sh"
grep -Fq '== / ]]' "${root}/scripts/audit-template.sh"
grep -Fq 'FROM alpine:3.23.6@sha256:85fe1e81d6758c208f3e1eed4338a1997e19d4be002d4dd32d3100c9a8c010a0' "${root}/Dockerfile"
grep -Fq 'FROM ghcr.io/go-shiori/shiori:v1.8.0@sha256:d3bdfc1b68b8f267a04cf74d73b8a0e1d99ac71c3a9047375e97202f079eb1f6' "${root}/Dockerfile"
graph="$(cd "${root}" && ./node_modules/.bin/railway-iac-ts .railway/railway.ts)"
jq -e '.ok==true and ([.graph.resources[]|select(.type=="service")|.name])==["Shiori"] and ([.graph.resources[]|select(.type=="volume")]|length)==1' <<<"${graph}" >/dev/null
jq -e '.graph.resources[]|select(.name=="Shiori")|.source.repo=="tech-progress/railway-template-shiori" and .source.branch=="release-v1" and .source.rootDirectory=="/" and .build.builder=="DOCKERFILE"' <<<"${graph}" >/dev/null
for pin in d3bdfc1b68b8f267a04cf74d73b8a0e1d99ac71c3a9047375e97202f079eb1f6 85fe1e81d6758c208f3e1eed4338a1997e19d4be002d4dd32d3100c9a8c010a0; do grep -qs "${pin}" "${root}/Dockerfile"; done
grep -q '^# Deploy and Host' "${root}/MARKETPLACE.md"; echo "Shiori source, wrapper, generated owner, persistent session secret, and volume are valid."
