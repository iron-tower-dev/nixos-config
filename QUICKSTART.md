# Quick Start Guide

> **New to this repo?** Start here for the fastest path to a working system!

## 🚀 For New Installation

### Step 1: Create Bootable USB
```bash
# Download NixOS ISO from nixos.org
# Write to USB
sudo dd if=nixos-*.iso of=/dev/sdX bs=4M status=progress
```

### Step 2: Install Minimal NixOS
Boot USB and run:
```bash
# Partition disk (⚠️ ERASES DATA!)
sudo fdisk /dev/nvme0n1  # or /dev/sda
# Create 512MB EFI partition + root partition

# Format
sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
sudo mkfs.ext4 -L NIXOS /dev/nvme0n1p2

# Mount
sudo mount /dev/disk/by-label/NIXOS /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot

# Generate and edit config
sudo nixos-generate-config --root /mnt
sudo nano /mnt/etc/nixos/configuration.nix
# (Add: flakes, networkmanager, user 'derrick')

# Install
sudo nixos-install
reboot
```

### Step 3: Clone This Repo
After booting into new system:
```bash
cd ~
git clone https://github.com/iron-tower-dev/nixos-config.git
cd nixos-config
```

### Step 4: Configure for Your Machine
```bash
# Generate hardware config
sudo nixos-generate-config --show-hardware-config > \
  hosts/iron-tower/hardware-configuration.nix  # or iron-zephyrus

# Set hostname
sudo hostnamectl set-hostname iron-tower  # or iron-zephyrus

# For laptop: Find GPU bus IDs
lspci | grep -E "(VGA|3D)"
# Update hosts/iron-zephyrus/configuration.nix with bus IDs
```

### Step 5: Build
```bash
# Check syntax
nix flake check

# Build (takes 10-30 min first time)
sudo nixos-rebuild switch --flake .#iron-tower  # or iron-zephyrus

# Reboot
sudo reboot
```

### Step 6: Set Up GitHub
After logging into Hyprland:
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "derricksouthworth@gmail.com" -f ~/.ssh/github

# Show public key
cat ~/.ssh/github.pub

# Add to GitHub: https://github.com/settings/keys

# Test
ssh -T git@github.com

# Auth GitHub CLI
gh auth login
```

**Done!** 🎉

---

## 📖 For Existing Installation

### Daily Commands
```bash
# Rebuild after changes
sudo nixos-rebuild switch --flake .#$(hostname)

# Or use alias
nrs

# Update packages
nix flake update
sudo nixos-rebuild switch --flake .#$(hostname)

# Clean up
sudo nix-collect-garbage -d
```

### Syncing Between Machines
```bash
# On machine 1
git add .
git commit -m "Update config"
git push

# On machine 2
git pull
sudo nixos-rebuild switch --flake .#$(hostname)
```

---

## 📚 Full Documentation

- **New Installation**: `INSTALL.md` - Complete step-by-step guide
- **Setup Summary**: `SETUP_SUMMARY.md` - Post-install tasks
- **Multi-Host**: `MULTI_HOST_SETUP.md` - Managing multiple machines
- **GitHub Setup**: `GITHUB_SETUP.md` - SSH/Git configuration
- **Waybar**: `home/WAYBAR_GUIDE.md` - Customizing the bar
- **README**: `README.md` - Feature overview

---

## 🆘 Quick Troubleshooting

**Build fails?**
```bash
sudo nixos-rebuild switch --flake .#$(hostname) --show-trace
```

**Wrong hostname?**
```bash
sudo hostnamectl set-hostname iron-tower
```

**WiFi not working?**
```bash
nmtui
```

**Can't push to GitHub?**
```bash
# Set up SSH first (see GITHUB_SETUP.md)
ssh-keygen -t ed25519 -C "derricksouthworth@gmail.com" -f ~/.ssh/github
```

---

## ⌨️ Essential Keybindings

- `Super + Return` - Terminal
- `Super + D` - App launcher
- `Super + Q` - Close window
- `Super + 1-9` - Switch workspace
- `Super + S` - Screenshot
- `Super + E` - File manager

---

## 🎯 Quick Facts

- **Hosts**: iron-tower (desktop), iron-zephyrus (laptop)
- **User**: derrick
- **Git**: Derrick Southworth <derricksouthworth@gmail.com>
- **GitHub**: iron-tower-dev
- **Window Manager**: Hyprland
- **Shell**: Fish
- **Editor**: Neovim

---

Need more help? Read `INSTALL.md` for the complete guide!
