#!/usr/bin/env bash
set -euo pipefail
base_url="${SHIORI_URL:-http://127.0.0.1:18080}"; app_user="${SHIORI_USERNAME:-owner}"; app_password="${SHIORI_PASSWORD:?Set SHIORI_PASSWORD}"
for _ in {1..120}; do code="$(curl -s -o /dev/null -w '%{http_code}' "${base_url}/" || true)"; [[ "${code}" == 200 ]] && break; sleep 2; done
[[ "${code}" == 200 ]]
[[ "$(curl -s -o /dev/null -w '%{http_code}' -H 'Content-Type: application/json' --data '{"username":"shiori","password":"gopher","remember_me":false}' "${base_url}/api/v1/auth/login")" == 400 ]]
login="$(curl -fsS -H 'Content-Type: application/json' --data "$(jq -nc --arg u "${app_user}" --arg p "${app_password}" '{username:$u,password:$p,remember_me:false}')" "${base_url}/api/v1/auth/login")"
token="$(jq -r .message.token <<<"${login}")"; [[ -n "${token}" && "${token}" != null ]]
marker="railway-shiori-smoke"
if [[ "${SHIORI_SKIP_CREATE:-0}" != 1 ]]; then curl -fsS -H "Authorization: Bearer ${token}" -H 'Content-Type: application/json' --data "$(jq -nc --arg u "https://example.com/?${marker}" '{url:$u,title:"Railway smoke",createArchive:false,public:0,tags:[{name:"railway-template"}]}')" "${base_url}/api/bookmarks" >/dev/null; fi
bookmarks="$(curl -fsS -H "Authorization: Bearer ${token}" "${base_url}/api/bookmarks")"; grep -q "${marker}" <<<"${bookmarks}"
echo "Shiori generated-owner login and persisted bookmark readback passed."
