#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="rideshare"

echo "==> Building Docker image: $IMAGE_NAME"

docker build --no-cache --tag "$IMAGE_NAME" \
  --progress=plain \
  .

echo "==> Done."
