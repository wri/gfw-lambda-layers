#!/bin/bash
set -euo pipefail

BUCKET="$1"
KEY="$2"
OUT="$3"

downloaded="false"

# Try to download existing artifact; if missing, we'll build.
if aws s3 cp "s3://${BUCKET}/${KEY}" "${OUT}" >/dev/null 2>&1; then
  downloaded="true"
else
  # Ensure file exists so terraform plan can reference it
  : > "${OUT}"   # create empty file deterministically
fi

md5="$(md5sum "${OUT}" | awk '{print $1}')"

echo '{ "source": "'"${OUT}"'", "downloaded": "'"${downloaded}"'", "local_md5": "'"${md5}"'" }'
