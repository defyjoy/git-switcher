# Installation

## Quick install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/defyjoy/git-switcher/main/install.sh | bash
```

This installs:

- `~/.local/bin/git-use`
- `~/.local/bin/git-switcher` (symlink)

### PATH

If `~/.local/bin` is not on your `PATH`, add it:

```bash
# zsh — ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

# bash — ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:

```bash
source ~/.zshrc   # or: source ~/.bashrc
```

## Install from clone

```bash
git clone git@github.com:defyjoy/git-switcher.git
cd git-switcher
./install.sh
```

## SSH config setup

1. Keep real keys as separate files (examples):

   - `~/.ssh/github` → personal account  
   - `~/.ssh/xyz` → xyz account

2. Point `github.com` at a **symlink path** (not a profile key file):

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/github-active
```

3. Add one Host profile per account (names are what you pass to `git-use`):

```sshconfig
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

4. Initialize the active symlink once:

```bash
ln -sfn ~/.ssh/github ~/.ssh/github-active
```

5. Verify:

```bash
git-use doctor
git-use list
git-use xyz
ssh -T git@github.com
```

## Upgrade

Re-run the same install command:

```bash
curl -fsSL https://raw.githubusercontent.com/defyjoy/git-switcher/main/install.sh | bash
```

Or from a clone: `git pull && ./install.sh`

## Uninstall

```bash
rm -f ~/.local/bin/git-use ~/.local/bin/git-switcher
# optional: remove symlink used by Host github.com
# rm -f ~/.ssh/github-active
```
