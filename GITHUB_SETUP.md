# GitHub SSH Setup Guide

This guide will help you set up SSH authentication for GitHub on your NixOS systems.

## Quick Setup

After building your NixOS configuration, follow these steps to set up GitHub authentication:

### 1. Generate SSH Key

Generate an ED25519 SSH key for GitHub:

```bash
ssh-keygen -t ed25519 -C "derricksouthworth@gmail.com" -f ~/.ssh/github
```

**Important**: 
- When prompted, enter a secure passphrase (recommended)
- The key will be saved to `~/.ssh/github` (private) and `~/.ssh/github.pub` (public)

### 2. Start SSH Agent and Add Key

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your SSH key to the agent
ssh-add ~/.ssh/github
```

To make this persistent, add to your shell configuration or the key will be added automatically due to `AddKeysToAgent yes` in the SSH config.

### 3. Copy Public Key

Display and copy your public key:

```bash
cat ~/.ssh/github.pub
```

Or copy directly to clipboard:

```bash
cat ~/.ssh/github.pub | wl-copy  # Wayland
# or
cat ~/.ssh/github.pub | xclip -selection clipboard  # X11
```

### 4. Add SSH Key to GitHub

1. Go to GitHub: https://github.com/settings/keys
2. Click **"New SSH key"**
3. Fill in the details:
   - **Title**: `iron-tower` or `iron-zephyrus` (depending on which machine you're on)
   - **Key type**: Authentication Key
   - **Key**: Paste your public key (from step 3)
4. Click **"Add SSH key"**
5. Confirm with your GitHub password if prompted

### 5. Test Connection

Verify your SSH connection to GitHub:

```bash
ssh -T git@github.com
```

You should see:
```
Hi iron-tower-dev! You've successfully authenticated, but GitHub does not provide shell access.
```

### 6. Configure GitHub CLI

Authenticate GitHub CLI:

```bash
gh auth login
```

Follow the prompts:
- **What account do you want to log into?** GitHub.com
- **What is your preferred protocol for Git operations?** SSH
- **Upload your SSH public key to your GitHub account?** Yes (select `~/.ssh/github.pub`)
- **How would you like to authenticate?** Login with a web browser
- Copy the one-time code and press Enter
- Complete authentication in your browser

Verify:
```bash
gh auth status
```

## Configuration Details

### Git Configuration

Your Git configuration is set up in `home/git.nix`:
- **Name**: Derrick Southworth
- **Email**: derricksouthworth@gmail.com
- **Default Branch**: main
- **Protocol**: SSH (for GitHub)

### SSH Configuration

SSH is configured to use the key at `~/.ssh/github` for GitHub connections.

The configuration (in `home/git.nix`) includes:
```ssh
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github
  AddKeysToAgent yes
```

## Per-Machine Setup

For each machine (iron-tower and iron-zephyrus):

1. **Generate a separate SSH key** (recommended) or reuse the same key
2. **Add each key to GitHub** with a descriptive name
3. **Test the connection** on each machine

### Separate Keys (Recommended)

```bash
# On iron-tower
ssh-keygen -t ed25519 -C "derricksouthworth@gmail.com" -f ~/.ssh/github
# Add to GitHub as "iron-tower"

# On iron-zephyrus
ssh-keygen -t ed25519 -C "derricksouthworth@gmail.com" -f ~/.ssh/github
# Add to GitHub as "iron-zephyrus"
```

### Shared Key

If you prefer to use the same key across machines:

1. Generate the key on one machine
2. Securely copy both `~/.ssh/github` and `~/.ssh/github.pub` to the other machine
3. Set correct permissions: `chmod 600 ~/.ssh/github && chmod 644 ~/.ssh/github.pub`
4. Add the key to GitHub once (works on both machines)

## Troubleshooting

### Permission Denied (publickey)

```bash
# Check if SSH agent is running
ssh-add -l

# If not, start it and add your key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github

# Test connection again
ssh -T git@github.com
```

### Key Not Being Used

Verify SSH is using the correct key:

```bash
ssh -vT git@github.com
```

Look for lines mentioning `~/.ssh/github`.

### Wrong Permissions

SSH keys need specific permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/github
chmod 644 ~/.ssh/github.pub
```

### GitHub CLI Not Authenticated

Re-authenticate:

```bash
gh auth logout
gh auth login
```

## Useful Commands

```bash
# List all SSH keys added to agent
ssh-add -l

# Remove all keys from agent
ssh-add -D

# Test GitHub connection
ssh -T git@github.com

# Check GitHub CLI status
gh auth status

# Clone a repo using SSH
gh repo clone iron-tower-dev/repo-name
# or
git clone git@github.com:iron-tower-dev/repo-name.git

# Set remote to use SSH
git remote set-url origin git@github.com:iron-tower-dev/repo-name.git
```

## SSH Agent Persistence

The SSH key will be automatically loaded when you use Git due to the `AddKeysToAgent yes` configuration. However, for persistence across reboots, you can:

### Option 1: Use keychain (Recommended)

Add to your shell configuration:

```fish
# Fish shell (~/.config/fish/config.fish)
if status is-interactive
    eval (keychain --eval --quiet ~/.ssh/github)
end
```

```bash
# Bash/Zsh (~/.bashrc or ~/.zshrc)
eval $(keychain --eval --quiet ~/.ssh/github)
```

### Option 2: Systemd User Service

The NixOS configuration can manage SSH agent automatically. This is already set up if you're using GNOME Keyring or KDE Wallet.

## Security Best Practices

1. **Always use a passphrase** for your SSH keys
2. **Use separate keys** for different machines
3. **Regularly rotate keys** (every 6-12 months)
4. **Remove old/unused keys** from GitHub
5. **Never commit private keys** to repositories
6. **Use SSH agent** to avoid typing passphrase repeatedly

## Additional Resources

- [GitHub SSH Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [SSH Key Types](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
