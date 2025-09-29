#!/usr/bin/env bash
set -euo pipefail

BUILD_PLAN="${1:-IosvekaCustom}"
BUILD_TARGETS="${2:-contents}"
CONFIG_DIR="./config"
THREADS="${THREADS:-2}"  # fallback jika env tidak tersedia

echo "🔹 Checking if Iosevka source exists..."
if [ ! -d "Iosevka" ]; then
  echo "Iosevka folder not found. Running setup..."
  gh workflow run setup.yml
  echo "Please re-run build after setup finishes."
  exit 1
fi

cd Iosevka

echo "🔹 Starting build for plan $BUILD_PLAN and targets $BUILD_TARGETS"
IFS=',' read -ra TARGET_ARRAY <<< "$BUILD_TARGETS"
for target in "${TARGET_ARRAY[@]}"; do
    echo "➡️ Building $target::$BUILD_PLAN with $THREADS threads"
    export JOBS=$THREADS
    npm run build -- "$target::$BUILD_PLAN"
done

echo "🔹 Build finished, dist files:"
ls -l dist/