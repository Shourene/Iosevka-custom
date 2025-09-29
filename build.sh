#!/usr/bin/env bash
set -e

TARGET="$1"

echo "[INFO] Clone Iosevka repo..."
rm -rf Iosevka
git clone --depth=1 https://github.com/be5invis/Iosevka.git
cd Iosevka

echo "[INFO] Copy private-build-plans.toml..."
cp ../private-build-plans.toml .

if [ ! -d "node_modules" ] || [ -z "$(ls -A node_modules)" ]; then
  echo "[INFO] node_modules not found, running npm install..."
  npm install
else
  echo "[INFO] Using cached node_modules"
fi

echo "[INFO] Start building with target: $TARGET"
npm run build -- "$TARGET::IosevkaCustom"

echo "[INFO] Prepare output..."
cd ..
rm -rf output
mkdir -p output
cp -r Iosevka/dist/IosevkaCustom/* output/

echo "[INFO] Compress output..."
zip -r output/IosevkaCustom.zip output/*