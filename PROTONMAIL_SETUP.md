# Proton Mail + Thunderbird Setup Guide

This configuration sets up Thunderbird with Proton Mail Bridge through Home Manager.

## What's Configured

### Thunderbird
- ✅ Installed and managed via Home Manager
- ✅ Default profile with optimized settings
- ✅ Set as default mail client for mailto links
- ✅ Privacy and security settings configured

### Proton Mail Bridge
- ✅ Installed system-wide via productivity module
- ✅ Desktop entry for easy access
- ✅ Systemd user service for auto-start
- ✅ Runs in background without window

## Setup Steps

### 1. Rebuild and Apply Configuration
```bash
sudo nixos-rebuild switch --flake .
```

### 2. Set Up Proton Mail Bridge
After rebuild:

1. **Start Proton Mail Bridge:**
   ```bash
   systemctl --user start protonmail-bridge
   ```

2. **Initial Setup (first time only):**
   ```bash
   protonmail-bridge
   ```
   - Login with your Proton Mail credentials
   - Set up your Bridge password
   - Note the IMAP/SMTP settings provided

3. **Enable auto-start:**
   ```bash
   systemctl --user enable protonmail-bridge
   ```

### 3. Configure Thunderbird Account

The Bridge will provide you with:
- **IMAP Server:** `127.0.0.1:1143` (or similar)
- **SMTP Server:** `127.0.0.1:1025` (or similar)
- **Username:** Your Proton Mail email
- **Password:** The Bridge password (not your Proton password)

1. Open Thunderbird
2. Add new account with the Bridge settings
3. Use the Bridge password, not your Proton Mail password

### 4. Verify Setup

Check that everything is working:
```bash
# Check if Bridge is running
systemctl --user status protonmail-bridge

# Check Thunderbird process
pgrep -f thunderbird
```

## Configuration Files

- **Home Manager:** `~/nixos-config/home/thunderbird.nix`
- **System packages:** `~/nixos-config/modules/productivity.nix`
- **Bridge service:** Managed by systemd user service

## Troubleshooting

### Bridge Not Starting
```bash
# Check service status
systemctl --user status protonmail-bridge

# Check logs
journalctl --user -u protonmail-bridge
```

### Connection Issues
- Ensure Bridge is running before starting Thunderbird
- Check firewall settings (usually not needed for localhost)
- Verify Bridge password is correct in Thunderbird

### Reset Configuration
```bash
# Stop and disable service
systemctl --user stop protonmail-bridge
systemctl --user disable protonmail-bridge

# Remove Bridge config (if needed)
rm -rf ~/.config/protonmail/bridge

# Restart setup process
protonmail-bridge
```

## Security Notes

- Bridge password is separate from your Proton Mail password
- All communication between Thunderbird and Bridge is local (localhost)
- Bridge handles encryption/decryption with Proton servers
- Keep Bridge updated for security patches