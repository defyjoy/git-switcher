# git-use (git-switcher)

Switch the active GitHub SSH key using **named Host profiles** in `~/.ssh/config`. Remotes stay `git@github.com:...` — no Host aliases in remote URLs.

## Install

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/defyjoy/git-switcher/main/install.sh | bash
```

### From clone

```bash
git clone git@github.com:defyjoy/git-switcher.git
cd git-switcher
./install.sh
```

Ensure `~/.local/bin` is on your `PATH`, then configure SSH profiles. Full steps: **[docs/install.md](docs/install.md)**.

## How it works

1. `Host github.com` points at a symlink (e.g. `~/.ssh/github-active`).
2. Profile Hosts (`personal`, `xyz`, …) each set `HostName github.com` and their own `IdentityFile`.
3. `git-use <profile>` reads that profile’s key and repoints the symlink.

## SSH config

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/github-active

# Profiles (names you pass to git-use)
Host personal
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/github

Host joydeeplili
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/lilisolutions
```

Initialize once:

```bash
ln -sfn ~/.ssh/github ~/.ssh/github-active
```

## Usage

```bash
git-use list           # profiles from ssh config
git-use xyz            # switch + ssh -T
git-use personal
git-use status
git-use doctor
```

`git-switcher` and `gu` are shortcuts for the same binary.

## Docs

- [Installation](docs/install.md)
- [Usage](docs/usage.md)
