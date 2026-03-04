#!/usr/bin/env bash
set -euo pipefail

LAYER_PATH="${1}"

# Hash the contents of the layer directory in a stable way.
# Exclude build outputs and other noise.
# Include lockfiles / manifests so dependency bumps trigger a rebuild.
(
  cd "${LAYER_PATH}"

  # List all files deterministically, exclude layer.zip and known junk
  find . -type f \
    ! -name 'layer.zip' \
    ! -name 'foo.txt' \
    ! -path './.terraform/*' \
    ! -path './__pycache__/*' \
    ! -path './.pytest_cache/*' \
    -print0 \
  | LC_ALL=C sort -z \
  | xargs -0 sha256sum \
  | sha256sum \
  | awk '{print $1}'
) | awk '{print "{ \"hash\": \"" $1 "\" }"}'
