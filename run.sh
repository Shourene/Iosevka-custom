#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
BUILD_PLAN="${1:-IosvekaCustom}"          # Nama build plan dari argumen
BUILD_TARGETS="${2:-contents}"            # Target build, koma-separate
CONFIG_DIR="./config"
WORKFLOW_CONFIG="$CONFIG_DIR/workflow.toml"
PRIVATE_BUILD_PLANS="$CONFIG_DIR/private-build-plans.toml"

# === READ THREADS ===
THREADS=$(python3 -c "import tomllib; print(tomllib.load(open('$WORKFLOW_CONFIG','rb'))['threads'])")
echo "Using $THREADS threads for build"

# === INSTALL DEPENDENCIES ===
echo "🔹 Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y nodejs npm ttfautohint fontforge python3-pip git jq curl

# === CLONE IOSEVKA SOURCE ===
if [ ! -d "Iosevka" ]; then
    echo "🔹 Cloning Iosevka repository..."
    git clone --depth=1 https://github.com/be5invis/Iosevka.git
fi

# Copy private build plans
cp "$PRIVATE_BUILD_PLANS" Iosevka/private-build-plans.toml

# === INSTALL NPM DEPENDENCIES ===
echo "🔹 Installing npm dependencies..."
cd Iosevka
npm install

# === RUN BUILD PER TARGET ===
IFS=',' read -ra TARGET_ARRAY <<< "$BUILD_TARGETS"
for target in "${TARGET_ARRAY[@]}"; do
    echo "➡️ Building $target::$BUILD_PLAN with $THREADS threads"
    export JOBS=$THREADS
    npm run build -- "$target::$BUILD_PLAN"
done

# === UPLOAD ARTIFACTS ===
echo "🔹 Build finished, dist files:"
ls -l dist/

cd ..

# === DELETE OLD TAG/RELEASE ===
TAG="build-${GITHUB_RUN_ID:-manual}-$(date +'%Y%m%d')"
REPO="${GITHUB_REPOSITORY:-user/repo}"   # fallback jika dijalankan manual

if gh release view "$TAG" &>/dev/null || git ls-remote --tags | grep -q "$TAG"; then
    echo "🔹 Deleting previous release/tag $TAG..."
    gh release delete "$TAG" -y || echo "No release found"
    git push origin --delete "$TAG" || echo "No remote tag to delete"
else
    echo "No previous release/tag $TAG found, skipping deletion"
fi