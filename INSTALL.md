# NixOS Installation Guide

Complete guide for installing NixOS with this configuration on a new machine.

## 📋 Prerequisites

- USB drive (4GB+)
- Internet connection
- Target machine (iron-tower or iron-zephyrus)
- GitHub account with SSH key access

## 🎯 Installation Overview

1. Create bootable USB
2. Boot into NixOS installer
3. Partition and format drives
4. Install minimal NixOS
5. Boot into new system
6. Clone this configuration
7. Generate hardware config
8. Build full configuration
9. Set up GitHub access

---

## Part 1: Create Bootable USB

### Download NixOS

Download the latest NixOS ISO:
- **URL**: https://nixos.org/download.html#nixos-iso
- **Choose**: Graphical ISO (GNOME) or Minimal ISO
- **Recommended**: Graphical ISO for easier installation

### Create Bootable USB

**On Linux:**
```bash
# Find your USB device (be careful!)
lsblk

# Write ISO to USB (replace sdX with your device)
sudo dd if=nixos-gnome-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

**On Windows:**
- Use [Rufus](https://rufus.ie/)
- Select the NixOS ISO
- Use DD mode

**On macOS:**
```bash
# Find device
diskutil list

# Unmount
diskutil unmountDisk /dev/diskX

# Write
sudo dd if=nixos-gnome-*.iso of=/dev/rdiskX bs=1m
```

---

## Part 2: Boot and Prepare Installation

### 1. Boot from USB

- Insert USB drive
- Restart computer
- Access boot menu (usually F12, F11, ESC, or DEL)
- Select USB drive
- Choose "NixOS" from the boot menu

### 2. Connect to Internet

**Ethernet:** Should work automatically

**WiFi:**
```bash
# Start interactive WiFi setup
sudo systemctl start wpa_supplicant

# Or use nmtui (if available)
sudo nmtui
```

Test connection:
```bash
ping -c 3 nixos.org
```

### 3. Set Up Partitions

⚠️ **DANGER**: This will erase all data on the drive!

#### Choose Your Partition Scheme

**UEFI Systems (Modern - Recommended):**
```bash
# List disks
lsblk

# Open partitioning tool (replace nvme0n1 with your disk)
sudo fdisk /dev/nvme0n1  # or /dev/sda for SATA drives
```

**Create Partitions:**

| Partition | Type | Size | Mount Point | Purpose |
|-----------|------|------|-------------|---------|
| /dev/nvme0n1p1 | EFI | 512MB | /boot | Boot partition |
| /dev/nvme0n1p2 | Linux | Remaining | / | Root filesystem |

**Partitioning Steps:**
```bash
# In fdisk:
g           # Create GPT partition table
n           # New partition
1           # Partition number 1
<Enter>     # Default start
+512M       # 512MB for boot
t           # Change type
1           # EFI System

n           # New partition
2           # Partition number 2
<Enter>     # Default start
<Enter>     # Use remaining space

w           # Write changes and exit
```

#### Format Partitions

```bash
# Format boot partition (FAT32 for UEFI)
sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1

# Format root partition (ext4)
sudo mkfs.ext4 -L NIXOS /dev/nvme0n1p2
```

#### Mount Filesystems

```bash
# Mount root
sudo mount /dev/disk/by-label/NIXOS /mnt

# Create boot directory
sudo mkdir -p /mnt/boot

# Mount boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot
```

---

## Part 3: Install Minimal NixOS

### 1. Generate Initial Configuration

```bash
sudo nixos-generate-config --root /mnt
```

This creates:
- `/mnt/etc/nixos/configuration.nix`
- `/mnt/etc/nixos/hardware-configuration.nix`

### 2. Edit Configuration

```bash
sudo nano /mnt/etc/nixos/configuration.nix
```

**Minimal working configuration:**
```nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-temp";  # Temporary name
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Create user
  users.users.derrick = {
    isNormalUser = true;
    description = "Derrick";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "changeme";
  };

  # Enable SSH for remote access (optional)
  services.openssh.enable = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
  ];

  system.stateVersion = "24.05";
}
```

### 3. Install NixOS

```bash
sudo nixos-install
```

This will:
- Install the base system
- Set up the bootloader
- Create user accounts

### 4. Set Root Password

When prompted, set a password for root:
```
Enter root password: <type password>
Confirm: <type password again>
```

### 5. Reboot

```bash
reboot
```

Remove the USB drive when prompted.

---

## Part 4: Initial Boot and Setup

### 1. Log In

- Username: `derrick`
- Password: `changeme` (or what you set)

### 2. Connect to Internet

```bash
# If using WiFi
nmtui
```

Test:
```bash
ping -c 3 nixos.org
```

### 3. Change User Password

```bash
passwd
```

---

## Part 5: Clone Configuration Repository

### Option A: Using HTTPS (Initial Setup)

```bash
# Clone repository
cd ~
git clone https://github.com/iron-tower-dev/nixos-config.git
cd nixos-config
```

### Option B: If Repository Doesn't Exist Yet

If you haven't pushed the config to GitHub yet:

1. **On your current machine** (where you prepared the config):
   ```bash
   cd ~/nixos-config
   
   # Initialize git if needed
   git init
   git add .
   git commit -m "Initial NixOS configuration"
   
   # Create GitHub repository
   gh repo create nixos-config --private --source=. --push
   
   # Or manually:
   # 1. Create repo on GitHub
   # 2. git remote add origin git@github.com:iron-tower-dev/nixos-config.git
   # 3. git push -u origin main
   ```

2. **On new machine**:
   ```bash
   cd ~
   git clone https://github.com/iron-tower-dev/nixos-config.git
   cd nixos-config
   ```

---

## Part 6: Configure for This Machine

### 1. Determine Hostname

```bash
# Check current hostname
hostname

# Decide: iron-tower (desktop) or iron-zephyrus (laptop)
```

### 2. Generate Hardware Configuration

```bash
cd ~/nixos-config

# For iron-tower
sudo nixos-generate-config --show-hardware-config > hosts/iron-tower/hardware-configuration.nix

# For iron-zephyrus
sudo nixos-generate-config --show-hardware-config > hosts/iron-zephyrus/hardware-configuration.nix
```

### 3. Configure NVIDIA (iron-zephyrus only)

Find GPU bus IDs:
```bash
lspci | grep -E "(VGA|3D)"
```

Output example:
```
01:00.0 VGA compatible controller: NVIDIA Corporation ...
00:02.0 VGA compatible controller: Advanced Micro Devices ...
```

Edit `hosts/iron-zephyrus/configuration.nix`:
```bash
nano hosts/iron-zephyrus/configuration.nix
```

Update lines ~72-73:
```nix
amdgpuBusId = "PCI:0:2:0";   # From lspci (00:02.0 → 0:2:0)
nvidiaBusId = "PCI:1:0:0";   # From lspci (01:00.0 → 1:0:0)
```

### 4. Set Correct Hostname

```bash
sudo hostnamectl set-hostname iron-tower
# or
sudo hostnamectl set-hostname iron-zephyrus
```

---

## Part 7: Build Full Configuration

### 1. Review Configuration

```bash
# Check flake syntax
nix flake check

# Review what will be built
nix flake show
```

### 2. Build Configuration

```bash
# For iron-tower
sudo nixos-rebuild switch --flake .#iron-tower

# For iron-zephyrus
sudo nixos-rebuild switch --flake .#iron-zephyrus
```

This will:
- Download all packages (~2-5GB)
- Build the system
- Configure Hyprland, Waybar, etc.
- Set up home-manager
- Install development tools

**Note:** First build takes 10-30 minutes depending on internet speed.

### 3. Reboot

```bash
sudo reboot
```

---

## Part 8: Post-Installation Setup

### 1. Log In to Hyprland

After reboot:
- You'll see the greetd login screen
- Enter username: `derrick`
- Enter your password
- Hyprland should start automatically

### 2. Verify Installation

Open terminal (Super + Return) and check:
```bash
# Check hostname
hostname

# Check Waybar is running
pgrep waybar

# Check Hyprland
hyprctl version

# Test internet
ping -c 3 google.com
```

### 3. Set Up GitHub SSH

Follow the complete guide in `GITHUB_SETUP.md`, or quick version:

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "derricksouthworth@gmail.com" -f ~/.ssh/github

# Display public key
cat ~/.ssh/github.pub

# Copy the output and add to GitHub:
# https://github.com/settings/keys
# Click "New SSH key"
# Title: iron-tower (or iron-zephyrus)
# Paste the key

# Test connection
ssh -T git@github.com

# Should see: "Hi iron-tower-dev! You've successfully authenticated..."
```

### 4. Authenticate GitHub CLI

```bash
gh auth login

# Follow prompts:
# - GitHub.com
# - SSH
# - Upload your SSH key (choose ~/.ssh/github.pub)
# - Login with web browser
```

### 5. Switch Git Remote to SSH

```bash
cd ~/nixos-config

# Change from HTTPS to SSH
git remote set-url origin git@github.com:iron-tower-dev/nixos-config.git

# Verify
git remote -v

# Test push
git pull
```

---

## Part 9: First Update

### 1. Make a Test Change

```bash
cd ~/nixos-config

# Edit a file to test
echo "# Installed on $(date)" >> README.md
```

### 2. Commit and Push

```bash
git add .
git commit -m "Installed on $(hostname) - $(date +%Y-%m-%d)"
git push
```

### 3. Update System

```bash
# Update flake inputs
nix flake update

# Rebuild with updates
sudo nixos-rebuild switch --flake .#$(hostname)
```

---

## 🎨 Post-Setup Customization

### Configure Displays (Hyprland)

Edit `home/hyprland.nix`:
```bash
nano home/hyprland.nix
```

Update monitor configuration (around line 8):
```nix
monitor = [
  # Single monitor
  ",preferred,auto,1"
  
  # Or multiple monitors (example)
  # "DP-1,2560x1440@144,0x0,1"
  # "HDMI-1,1920x1080@60,2560x0,1"
];
```

Rebuild:
```bash
sudo nixos-rebuild switch --flake .#$(hostname)
```

### Change Wallpaper

Edit `modules/stylix.nix`:
```bash
nano modules/stylix.nix
```

Update wallpaper path or URL, then rebuild.

### Add More Packages

**System-wide:** Edit `modules/system.nix`
**User-level:** Edit `home/home.nix`

Then rebuild.

---

## 🔧 Troubleshooting Installation

### Boot Fails After Installation

1. Boot back into installer USB
2. Mount partitions:
   ```bash
   sudo mount /dev/disk/by-label/NIXOS /mnt
   sudo mount /dev/disk/by-label/BOOT /mnt/boot
   ```
3. Chroot:
   ```bash
   sudo nixos-enter
   ```
4. Fix configuration and rebuild:
   ```bash
   nixos-rebuild switch
   ```

### Flake Build Fails

```bash
# Show detailed error
sudo nixos-rebuild switch --flake .#$(hostname) --show-trace

# Common issues:
# - Wrong hostname: Check flake.nix
# - Missing hardware config: Regenerate it
# - Network issues: Check internet connection
```

### WiFi Not Working After Reboot

```bash
# Check NetworkManager
systemctl status NetworkManager

# Restart it
sudo systemctl restart NetworkManager

# Connect manually
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"
```

### NVIDIA Issues (iron-zephyrus)

```bash
# Check if driver loaded
lsmod | grep nvidia

# Check configuration
cat hosts/iron-zephyrus/configuration.nix | grep -A 10 "nvidia"

# Verify bus IDs
lspci | grep -E "(VGA|3D)"
```

### Can't Clone Repository

If you get authentication errors:
```bash
# Make sure you're using HTTPS initially
git clone https://github.com/iron-tower-dev/nixos-config.git

# Set up SSH later
```

---

## 📚 Quick Reference

### Essential Commands

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#$(hostname)

# Test without applying
sudo nixos-rebuild build --flake .#$(hostname)

# Update packages
nix flake update
sudo nixos-rebuild switch --flake .#$(hostname)

# Clean old generations
sudo nix-collect-garbage -d

# Rollback
sudo nixos-rebuild switch --rollback
```

### Key Locations

- Configuration: `~/nixos-config/`
- System config: `/etc/nixos/` (not used with flakes)
- User config: `~/.config/`
- Packages: `/nix/store/`

### Getting Help

- Detailed setup: `SETUP_SUMMARY.md`
- Multi-host: `MULTI_HOST_SETUP.md`
- GitHub: `GITHUB_SETUP.md`
- Waybar: `home/WAYBAR_GUIDE.md`

---

## ✅ Checklist

After installation, verify:

- [ ] System boots to Hyprland
- [ ] Waybar displays at top
- [ ] Terminal opens (Super + Return)
- [ ] Internet works
- [ ] GitHub SSH authentication works
- [ ] Can push to nixos-config repository
- [ ] Audio works (test with volume controls)
- [ ] Display(s) configured correctly
- [ ] GPU working (check `nvidia-smi` on laptop)

---

## 🎉 Done!

Your NixOS system is now fully configured with:
- ✅ Hyprland window manager
- ✅ Waybar status bar
- ✅ Development environments
- ✅ Gaming setup
- ✅ Git/GitHub integration
- ✅ Modern shell (Fish)
- ✅ All your customizations

Next: Read `SETUP_SUMMARY.md` for advanced usage!
