#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for sequelize/website
# Runs on existing source tree (no clone). Installs deps, pre-build steps, builds.
# sequelize/website needs .sequelize/v6 and .sequelize/v7 cloned for TypeScript source imports.

# --- Node version ---
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -f "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    nvm install 20
    nvm use 20
fi
echo "[INFO] Node: $(node --version)"
echo "[INFO] Yarn: $(yarn --version)"

# --- Install dependencies (Yarn classic) ---
yarn install --frozen-lockfile

# --- Clone sequelize core repos (needed for TypeScript source imports in docs) ---
# The staging repo does not include these (gitignored), so we clone fresh.
if [ ! -d ".sequelize/v7" ]; then
    git clone --depth 1 --branch main https://github.com/sequelize/sequelize.git .sequelize/v7
fi
if [ ! -d ".sequelize/v6" ]; then
    git clone --depth 1 --branch v6 https://github.com/sequelize/sequelize.git .sequelize/v6
fi

# --- Build Docusaurus site ---
yarn build

echo "[DONE] Build complete."
