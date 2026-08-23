#!/usr/bin/env bash
# Install git-use into ~/.local/bin
# Local:  ./install.sh
# Remote: curl -fsSL https://raw.githubusercontent.com/defyjoy/git-switcher/main/install.sh | bash
set -euo pipefail

REPO_RAW="${GIT_SWITCHER_RAW:-https://raw.githubusercontent.com/defyjoy/git-switcher/main}"
BIN_DIR="${HOME}/.local/bin"
DEST="${BIN_DIR}/git-use"
ALIAS_BEGIN="# >>> git-use >>>"
ALIAS_END="# <<< git-use <<<"
ALIAS_BLOCK="${ALIAS_BEGIN}
alias gu='git-use'
${ALIAS_END}"

ROOT=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

mkdir -p "$BIN_DIR"

if [[ -n "$ROOT" && -f "${ROOT}/bin/git-use" ]]; then
  install -m 755 "${ROOT}/bin/git-use" "$DEST"
  echo "Installed from local clone → $DEST"
else
  TMP="$(mktemp)"
  trap 'rm -f "$TMP"' EXIT
  echo "Downloading git-use from ${REPO_RAW}/bin/git-use ..."
  curl -fsSL "${REPO_RAW}/bin/git-use" -o "$TMP"
  install -m 755 "$TMP" "$DEST"
  echo "Installed from GitHub → $DEST"
fi

ln -sfn "$DEST" "${BIN_DIR}/git-switcher"
# Prefer shell alias gu; remove any old binary/symlink named gu
rm -f "${BIN_DIR}/gu"

install_shell_alias() {
  local rc="$1"
  local tmp
  if [[ ! -e "$rc" ]]; then
    touch "$rc"
  fi
  if grep -qF "$ALIAS_BEGIN" "$rc" 2>/dev/null; then
    tmp="$(mktemp)"
    awk -v begin="$ALIAS_BEGIN" -v end="$ALIAS_END" '
      $0 == begin { inblock=1; next }
      $0 == end { inblock=0; next }
      !inblock { print }
    ' "$rc" >"$tmp"
    mv "$tmp" "$rc"
    printf '\n%s\n' "$ALIAS_BLOCK" >>"$rc"
    echo "Updated alias gu in $rc"
  else
    printf '\n%s\n' "$ALIAS_BLOCK" >>"$rc"
    echo "Added alias gu='git-use' to $rc"
  fi
}

echo
echo "Binaries:"
echo "  ${BIN_DIR}/git-use"
echo "  ${BIN_DIR}/git-switcher → git-use"
echo

# Shell alias gu='git-use' for interactive shells
alias_installed=0
for rc in "${HOME}/.zshrc" "${HOME}/.bashrc" "${HOME}/.bash_profile"; do
  if [[ -f "$rc" ]]; then
    install_shell_alias "$rc"
    alias_installed=1
  fi
done
if [[ "$alias_installed" -eq 0 ]]; then
  install_shell_alias "${HOME}/.zshrc"
fi

echo
echo "Alias: gu → git-use (reload shell or: source ~/.zshrc)"
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
echo "  git-use doctor   # or: gu doctor"
echo "  git-use list"
echo "  git-use <profile>"
