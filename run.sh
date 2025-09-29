#!/usr/bin/env bash
set -euxo pipefail

BUILD_PLAN="${1:-IosvekaCustom}"
BUILD_TARGETS="${2:-contents}"
CONFIG_DIR="./config"

THREADS=$(python3 -c "import tomllib; print(tomllib.load(open('${CONFIG_DIR}/workflow.toml','rb'))['threads'])")
RELEASE_TAG=$(python3 -c "import tomllib; print(tomllib.load(open('${CONFIG_DIR}/workflow.toml','rb'))['release_tag'])")

echo "🔹 Using threads: $THREADS"
echo "🔹 Using release tag: $RELEASE_TAG"

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

ZIP_NAME="../${RELEASE_TAG}.zip"
echo "🔹 Zipping build results into $ZIP_NAME..."
zip -r "$ZIP_NAME" dist/*

echo "🔹 Build finished, dist files:"
ls -l dist/