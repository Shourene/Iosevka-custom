#!/usr/bin/env bash
set -euo pipefail

BUILD_PLAN="${1:-IosvekaCustom}"
BUILD_TARGETS="${2:-contents}"
CONFIG_DIR="./config"

THREADS=$(python3 -c "import tomllib; print(tomllib.load(open('${CONFIG_DIR}/workflow.toml','rb'))['threads'])")
RELEASE_TAG=$(python3 -c "import tomllib; print(tomllib.load(open('${CONFIG_DIR}/workflow.toml','rb'))['release_tag'])")

echo "🔹 Using threads: $THREADS"
echo "🔹 Using release tag: $RELEASE_TAG"

# Check if Iosevka folder exists and npm dependencies are installed
if [ ! -d "Iosevka" ] || [ ! -d "Iosevka/node_modules" ]; then
  echo "Iosevka folder or dependencies not found. Running setup..."
  if [ ! -x "./setup.sh" ]; then
    echo "setup.sh not found or not executable"
    exit 1
  fi
  chmod +x setup.sh
  ./setup.sh
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

ZIP_FILE="../${RELEASE_TAG}.zip"
echo "🔹 Creating zip file: $ZIP_FILE"
zip -r "$ZIP_FILE" dist/*

# Delete previous release/tag if exists
REPO="${GITHUB_REPOSITORY:-$(git config --get remote.origin.url | sed 's#.*/##;s/.git$//')}"
if command -v gh >/dev/null 2>&1 && [ -n "${GH_TOKEN:-}" ]; then
    if gh release view "$RELEASE_TAG" &>/dev/null || git ls-remote --tags https://github.com/$REPO.git | grep -q "$RELEASE_TAG"; then
        echo "Deleting previous release/tag $RELEASE_TAG..."
        gh release delete "$RELEASE_TAG" -y || echo "No release found"
        git push origin --delete "$RELEASE_TAG" || echo "No remote tag to delete"
    else
        echo "No previous release/tag $RELEASE_TAG found, skipping deletion"
    fi
fi

echo "🔹 Finished building: $ZIP_FILE"