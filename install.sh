#!/usr/bin/env bash
# Install github-use into ~/.local/bin
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
SRC="${ROOT}/bin/github-use"

mkdir -p "$BIN_DIR"
install -m 755 "$SRC" "${BIN_DIR}/github-use"
ln -sfn "${BIN_DIR}/github-use" "${BIN_DIR}/git-switcher"

echo "Installed:"
echo "  ${BIN_DIR}/github-use"
echo "  ${BIN_DIR}/git-switcher → github-use"
echo
echo "Ensure ~/.local/bin is on your PATH, then run: github-use doctor"
