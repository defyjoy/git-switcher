# github-use (git-switcher)

Switch the active GitHub SSH key using **named Host profiles** in `~/.ssh/config`. Remotes stay `git@github.com:...` — no Host aliases in remote URLs.

## How it works

1. `Host github.com` points at a symlink (e.g. `~/.ssh/github-active`).
2. Profile Hosts (`defyjoy`, `joydeeplili`, …) each set `HostName github.com` and their own `IdentityFile`.
3. `github-use <profile>` reads that profile’s key and repoints the symlink.

## SSH config

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/github-active

# Profiles (names you pass to github-use)
Host defyjoy
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

## Install

```bash
git clone git@github.com:defyjoy/git-switcher.git
cd git-switcher
./install.sh
```

Requires `~/.local/bin` on your `PATH`.

## Usage

```bash
github-use list           # profiles from ssh config
github-use joydeeplili     # switch + ssh -T
github-use defyjoy
github-use status
github-use doctor
```

`git-switcher` is an alias for the same binary.

## Docs

See [docs/usage.md](docs/usage.md).
