#!/usr/bin/env bash
# Install github-use into ~/.local/bin
# Local:  ./install.sh
# Remote: curl -fsSL https://raw.githubusercontent.com/defyjoy/git-switcher/main/install.sh | bash
set -euo pipefail

REPO_RAW="${GIT_SWITCHER_RAW:-https://raw.githubusercontent.com/defyjoy/git-switcher/main}"
BIN_DIR="${HOME}/.local/bin"
DEST="${BIN_DIR}/github-use"

ROOT=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

mkdir -p "$BIN_DIR"

if [[ -n "$ROOT" && -f "${ROOT}/bin/github-use" ]]; then
  install -m 755 "${ROOT}/bin/github-use" "$DEST"
  echo "Installed from local clone → $DEST"
else
  TMP="$(mktemp)"
  trap 'rm -f "$TMP"' EXIT
  echo "Downloading github-use from ${REPO_RAW}/bin/github-use ..."
  curl -fsSL "${REPO_RAW}/bin/github-use" -o "$TMP"
  install -m 755 "$TMP" "$DEST"
  echo "Installed from GitHub → $DEST"
fi

ln -sfn "$DEST" "${BIN_DIR}/git-switcher"

echo
echo "Binaries:"
echo "  ${BIN_DIR}/github-use"
echo "  ${BIN_DIR}/git-switcher → github-use"
echo

# PATH check
case ":${PATH}:" in
  *":${BIN_DIR}:"*)
    echo "PATH: ~/.local/bin is already on your PATH"
    ;;
  *)
    echo "PATH: add ~/.local/bin to your shell config, then reload:"
    echo
    echo "  # zsh (~/.zshrc)"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    echo "  # bash (~/.bashrc)"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    echo "  source ~/.zshrc   # or ~/.bashrc"
    ;;
esac

echo
echo "Next: configure SSH profiles (see docs/install.md), then:"
echo "  github-use doctor"
echo "  github-use list"
echo "  github-use <profile>"
