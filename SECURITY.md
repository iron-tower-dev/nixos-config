# Security & Privacy

This repository is **PUBLIC** and contains a NixOS configuration that can be safely shared.

## ✅ Safe to Share

This repository contains:
- **Configuration files** - System and application settings
- **Module definitions** - Reusable NixOS modules
- **Documentation** - Installation and setup guides
- **Scripts** - Helper scripts for system management
- **Placeholder hardware configs** - Template files that need to be regenerated on actual hardware

## 🔒 What's NOT Included

The following are explicitly excluded via `.gitignore`:
- ❌ SSH private keys
- ❌ GPG keys
- ❌ Age encryption keys
- ❌ Passwords or credentials
- ❌ API tokens
- ❌ Secrets of any kind

## 📋 Information That IS Public

### Personal Information
This repository contains:
- **Name**: Derrick Southworth
- **Email**: derricksouthworth@gmail.com (public, for Git commits)
- **GitHub Username**: iron-tower-dev
- **Hostnames**: iron-tower, iron-zephyrus

This is **intentional and safe** - these are public identifiers used for:
- Git commit attribution
- GitHub authentication
- System hostname identification

### System Configuration
- Software packages and versions
- Application preferences
- Keybindings and UI customizations
- Theme settings
- Development environment setup

## 🛡️ Security Best Practices

### For Users of This Config

1. **Generate your own hardware config**:
   ```bash
   sudo nixos-generate-config --show-hardware-config > \
     hosts/$(hostname)/hardware-configuration.nix
   ```

2. **Use your own SSH keys**:
   - Generate new SSH keys on each machine
   - Follow `GITHUB_SETUP.md` for instructions
   - NEVER commit private keys

3. **Change personal information**:
   - Update `home/git.nix` with your name/email
   - Change hostnames in `hosts/` if desired

4. **Keep secrets separate**:
   - Use 1Password or similar for passwords
   - Use environment variables for API keys
   - Consider using `sops-nix` or `agenix` for encrypted secrets

### What to Check Before Committing

Before running `git push`, always check:

```bash
# Check what's being committed
git status
git diff

# Search for potential secrets
grep -r "password\|secret\|token\|key" . --include="*.nix" | grep -v ".git"

# Check for private keys
find . -name "*.pem" -o -name "id_*" -o -name "*.key"

# Review .gitignore is working
git check-ignore -v <potentially-sensitive-file>
```

## 🔐 Encrypted Secrets (Future)

If you need to store secrets in the repository, consider:

### Option 1: sops-nix
```nix
# Use sops-nix for encrypted secrets
inputs.sops-nix.url = "github:Mic92/sops-nix";

# secrets.yaml (encrypted)
# Decrypt at build time
```

### Option 2: agenix
```nix
# Use agenix for age-encrypted secrets
inputs.agenix.url = "github:ryantm/agenix";

# secrets/*.age (encrypted files)
```

### Option 3: Environment Variables
```nix
# Read from environment at runtime
environment.variables = {
  API_KEY = builtins.getEnv "API_KEY";
};
```

## 📝 Privacy Considerations

### Information in This Repo

**Email Address (derricksouthworth@gmail.com)**:
- Used for Git commits (standard practice)
- Public on GitHub anyway
- Safe to share

**Hostnames (iron-tower, iron-zephyrus)**:
- Just names, no security risk
- Don't reveal network topology
- Can be changed if desired

**Hardware Configs**:
- Contain disk UUIDs (not sensitive)
- Placeholder files that need regeneration
- Don't include actual serial numbers or MAC addresses

### What's Safe to Share

✅ Application choices (Firefox, Discord, etc.)
✅ Configuration preferences
✅ Keybindings and shortcuts
✅ Theme and visual customization
✅ Development environment setup
✅ Package lists
✅ Module structure

### What to Keep Private

❌ SSH private keys
❌ GPG private keys
❌ Passwords
❌ API tokens
❌ OAuth credentials
❌ SSL certificates
❌ Database credentials
❌ Personal documents

## 🔍 Regular Security Audits

Periodically check for accidentally committed secrets:

```bash
# Check git history for secrets
git log -p | grep -i "password\|secret\|token"

# Use git-secrets (if installed)
git secrets --scan

# Use gitleaks (if installed)
gitleaks detect
```

## 🚨 If You Accidentally Commit a Secret

1. **Immediately rotate the compromised credential**
2. **Remove from git history**:
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch <file-with-secret>' \
     --prune-empty --tag-name-filter cat -- --all
   
   git push --force --all
   ```
3. **Consider the secret permanently compromised**
4. **Update your security practices**

## 📚 Additional Resources

- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [NixOS: Secrets management](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes)
- [sops-nix documentation](https://github.com/Mic92/sops-nix)
- [agenix documentation](https://github.com/ryantm/agenix)

## ✅ Security Checklist

Before making this repository public:

- [x] No SSH private keys committed
- [x] No passwords or credentials
- [x] No API tokens
- [x] .gitignore properly configured
- [x] Hardware configs are placeholders
- [x] Only public information included
- [x] Documentation explains security practices

**Status**: ✅ Safe to make public
