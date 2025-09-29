#!/usr/bin/env bash
set -euo pipefail

echo "🔹 Installing system dependencies"
sudo apt-get update
sudo apt-get install -y nodejs npm ttfautohint fontforge python3-pip git zip

if [ ! -d "Iosevka" ]; then
  echo "🔹 Cloning Iosevka..."
  git clone --depth=1 https://github.com/be5invis/Iosevka.git
  cp ./config/private-build-plans.toml Iosevka/private-build-plans.toml
fi

echo "🔹 Installing npm dependencies"
cd Iosevka
npm install
cd ..