# Usage

## Profile rules

A Host block is treated as a switchable profile when:

- `HostName` is `github.com` (or `ssh.github.com`)
- The Host name is **not** `github.com` (that entry is the active target)
- `IdentityFile` is set and the key file exists

## Commands

| Command | Description |
|---------|-------------|
| `github-use <profile>` | Point active `IdentityFile` symlink at the profile key, then `ssh -T` |
| `github-use list` | List profiles and key paths |
| `github-use status` | Show symlink target and authenticate |
| `github-use doctor` | Validate config |
| `github-use version` | Print version |

## Environment

| Variable | Default | Meaning |
|----------|---------|---------|
| `GIT_SWITCHER_SSH_CONFIG` | `~/.ssh/config` | Config file to parse |
| `GIT_SWITCHER_ACTIVE_HOST` | `github.com` | Host entry whose `IdentityFile` is switched |
| `GIT_SWITCHER_ACTIVE_KEY` | `~/.ssh/github-active` | Fallback path if `github.com` has no `IdentityFile` |

## Safety

If `Host github.com` still points at a real profile private key (not a dedicated symlink path), `github-use` refuses to overwrite it and tells you to set `IdentityFile ~/.ssh/github-active` first.

If it points at some other regular file, that file is copied to `*.bak` once, then replaced by a symlink.
