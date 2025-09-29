#!/usr/bin/env bash
set -euo pipefail

BUILD_PLAN="${1:-IosvekaCustom}"
BUILD_TARGETS="${2:-contents}"
CONFIG_DIR="./config"

THREADS=$(python3 -c "import tomllib; print(tomllib.load(open('${CONFIG_DIR}/workflow.toml','rb'))['threads'])")
RELEASE_TAG=$(python3 -c "import tomllib; print(tomllib.load(open('${CONFIG_DIR}/workflow.toml','rb'))['release_tag'])")

echo "🔹 Using threads: $THREADS"
echo "🔹 Using release tag: $RELEASE_TAG"

if [ ! -d "Iosevka" ]; then
  echo "Iosevka folder missing. Setup should run first!"
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