#!/usr/bin/env bash
set -e

echo "[INFO] Setup system dependencies..."
sudo apt-get update
sudo apt-get install -y ttfautohint zip curl

echo "[INFO] Install Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[INFO] System dependencies installed."