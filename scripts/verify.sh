#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for file in .railway/railway.ts Dockerfile railway-entrypoint.sh CHANGELOG.md FINDINGS.md LICENSE_REVIEW.md MARKETPLACE.md PUBLISHING.md README.md SUPPORT.md UPGRADE.md VERSION compose.yaml package.json template-defaults.json template-descriptions.json template-networking.json template-volumes.json scripts/audit-template.sh scripts/check-standalone.sh scripts/restore-template-draft.sh scripts/smoke.sh; do test -f "${root}/${file}"; done
[[ "$(<"${root}/VERSION")" == 1.0.1 ]]; for file in "${root}"/template-*.json; do jq empty "${file}"; done; for file in "${root}"/scripts/*.sh; do bash -n "${file}"; done; sh -n "${root}/railway-entrypoint.sh"
SHIORI_PASSWORD=verify docker compose -f "${root}/compose.yaml" config --quiet
graph="$(cd "${root}" && ./node_modules/.bin/railway-iac-ts .railway/railway.ts)"
jq -e '.ok==true and ([.graph.resources[]|select(.type=="service")|.name])==["Shiori"] and ([.graph.resources[]|select(.type=="volume")]|length)==1' <<<"${graph}" >/dev/null
jq -e '.graph.resources[]|select(.name=="Shiori")|.source.repo=="tech-progress/railway-template-shiori" and .source.branch=="release-v1" and .source.rootDirectory=="/" and .build.builder=="DOCKERFILE"' <<<"${graph}" >/dev/null
for pin in d3bdfc1b68b8f267a04cf74d73b8a0e1d99ac71c3a9047375e97202f079eb1f6 25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659; do grep -qs "${pin}" "${root}/Dockerfile"; done
grep -q '^# Deploy and Host' "${root}/MARKETPLACE.md"; echo "Shiori source, wrapper, generated owner, persistent session secret, and volume are valid."
