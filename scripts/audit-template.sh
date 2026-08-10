#!/usr/bin/env bash
set -euo pipefail
template_id="${1:?Usage: ./scripts/audit-template.sh TEMPLATE_ID [EXPECTED_STATUS]}"; expected_status="${2:-}"; root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
template="$(railway api 'query Audit($id:String!){template(id:$id){name status serializedConfig}}' --var "id=${template_id}" --compact)"
[[ "$(jq -r '.data.template.name' <<<"${template}")" == "Shiori bookmarks" ]]; [[ -z "${expected_status}" || "$(jq -r '.data.template.status' <<<"${template}")" == "${expected_status}" ]]
actual="$(jq -c '.data.template.serializedConfig.services[]|select(.name=="Shiori")' <<<"${template}")"; [[ "$(jq -r '.data.template.serializedConfig.services|length' <<<"${template}")" == 1 ]]
[[ "$(jq -r '.source.repo|sub("^https://github.com/";"")|sub("\\.git$";"")' <<<"${actual}")" == "skyeagle/railway-templates" ]]; [[ "$(jq -r '.source.branch' <<<"${actual}")" == main ]]; [[ "$(jq -r '.source.rootDirectory' <<<"${actual}")" == /shiori-bookmarks ]]; [[ "$(jq -r '.build.builder' <<<"${actual}")" == DOCKERFILE ]]
[[ "$(jq -r '.volumeMounts|to_entries[0].value.sizeMB' <<<"${actual}")" == 5000 ]]; [[ "$(jq -r '.networking.serviceDomains["<hasDomain>"].port' <<<"${actual}")" == 8080 ]]
while IFS=$'\t' read -r key value; do [[ "$(jq -r --arg k "${key}" '.variables[$k].defaultValue//""' <<<"${actual}")" == "$(printf '%b' "${value}")" ]]; done < <(jq -r '.Shiori|to_entries[]|[.key,.value]|@tsv' "${root}/template-defaults.json")
echo "Template ${template_id} matches Shiori source, generated owner, volume, and networking."
