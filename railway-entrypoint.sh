#!/bin/sh
set -eu
bootstrap_port=18080
bootstrap_url="http://127.0.0.1:${bootstrap_port}"
response_file="$(mktemp)"
cleanup() {
  rm -f "${response_file}"
  if [ -n "${bootstrap_pid:-}" ]; then kill "${bootstrap_pid}" 2>/dev/null || true; wait "${bootstrap_pid}" 2>/dev/null || true; fi
}
trap cleanup EXIT INT TERM

/usr/bin/shiori server -a 127.0.0.1 -p "${bootstrap_port}" &
bootstrap_pid=$!
for _ in $(seq 1 60); do
  curl --fail --silent "${bootstrap_url}/" >/dev/null && break
  sleep 1
done

login() {
  curl --fail --silent --show-error -H 'Content-Type: application/json' \
    --data "{\"username\":\"${1}\",\"password\":\"${2}\",\"remember_me\":false}" \
    "${bootstrap_url}/api/v1/auth/login" >"${response_file}"
}

if ! login "${SHIORI_USERNAME}" "${SHIORI_PASSWORD}"; then
  login shiori gopher
  token="$(sed -n 's/.*"token":"\([^"]*\)".*/\1/p' "${response_file}")"
  [ -n "${token}" ]
  curl --fail --silent --show-error -X PATCH -H "Authorization: Bearer ${token}" -H 'Content-Type: application/json' \
    --data "{\"old_password\":\"gopher\",\"new_password\":\"${SHIORI_PASSWORD}\",\"username\":\"${SHIORI_USERNAME}\"}" \
    "${bootstrap_url}/api/v1/auth/account" >/dev/null
fi

kill "${bootstrap_pid}"
wait "${bootstrap_pid}" 2>/dev/null || true
bootstrap_pid=
trap - EXIT INT TERM
exec /usr/bin/shiori server -a 0.0.0.0 -p "${PORT:-8080}"
