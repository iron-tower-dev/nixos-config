# Multi-Host NixOS Configuration Guide

This configuration supports multiple machines with host-specific settings.

## Configured Hosts

### 🖥️ iron-tower (Desktop)
- **Type**: Desktop workstation
- **Purpose**: Primary development and gaming machine
- **Configuration**: `hosts/iron-tower/`

### 💻 iron-zephyrus (Laptop)
- **Type**: ASUS G14 Zephyrus Gaming Laptop
- **Purpose**: Portable development and gaming
- **Configuration**: `hosts/iron-zephyrus/`
- **Special Features**: 
  - NVIDIA GPU switching (PRIME)
  - Battery optimization
  - ASUS-specific utilities (asusctl, supergfxctl)
  - Touchpad and power management

## Directory Structure

```
nixos-config/
├── flake.nix                      # Multi-host definitions
├── configuration.nix              # Shared configuration
├── hosts/                         # Host-specific configs
│   ├── iron-tower/
│   │   ├── configuration.nix      # Desktop-specific settings
│   │   └── hardware-configuration.nix
│   └── iron-zephyrus/
│       ├── configuration.nix      # Laptop-specific settings
│       └── hardware-configuration.nix
├── modules/                       # Shared system modules
└── home/                          # Shared home-manager config
```

## Initial Setup on New Machine

### 1. Install NixOS

Follow standard NixOS installation, then:

```bash
# Boot into the installed system
# Clone this repository
git clone https://github.com/iron-tower-dev/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

### 2. Generate Hardware Configuration

Generate hardware-specific configuration for your machine:

```bash
# For iron-tower
sudo nixos-generate-config --show-hardware-config > hosts/iron-tower/hardware-configuration.nix

# For iron-zephyrus
sudo nixos-generate-config --show-hardware-config > hosts/iron-zephyrus/hardware-configuration.nix
```

### 3. Customize Host Configuration

Edit the host-specific configuration file:

**For iron-tower** (`hosts/iron-tower/configuration.nix`):
- Adjust GPU settings if you have NVIDIA
- Configure monitor layout in `home/hyprland.nix`

**For iron-zephyrus** (`hosts/iron-zephyrus/configuration.nix`):
- Find GPU bus IDs: `lspci | grep -E "(VGA|3D)"`
- Update NVIDIA PRIME configuration with correct bus IDs
- Adjust battery thresholds if desired

### 4. Build Configuration

Build for your specific host:

```bash
# For iron-tower
sudo nixos-rebuild switch --flake .#iron-tower

# For iron-zephyrus
sudo nixos-rebuild switch --flake .#iron-zephyrus
```

### 5. Set Up GitHub SSH

Follow the instructions in `GITHUB_SETUP.md` to configure Git and GitHub authentication.

## Updating Configuration

### On iron-tower

```bash
cd ~/nixos-config

# Make your changes to configuration files

# Build and switch
sudo nixos-rebuild switch --flake .#iron-tower

# Or use alias
nrs  # Rebuilds based on hostname
```

### On iron-zephyrus

```bash
cd ~/nixos-config

# Make your changes to configuration files

# Build and switch
sudo nixos-rebuild switch --flake .#iron-zephyrus

# Or use alias
nrs  # Rebuilds based on hostname
```

## Syncing Configuration Between Machines

### Method 1: Git (Recommended)

```bash
# On machine 1 (e.g., iron-tower)
cd ~/nixos-config
git add .
git commit -m "Update configuration"
git push

# On machine 2 (e.g., iron-zephyrus)
cd ~/nixos-config
git pull
sudo nixos-rebuild switch --flake .#iron-zephyrus
```

### Method 2: Direct Copy (Not Recommended)

Only use for testing; prefer Git for version control:

```bash
# Copy from iron-tower to iron-zephyrus
rsync -avz --exclude='.git' ~/nixos-config/ iron-zephyrus:~/nixos-config/
```

## Host-Specific Customization

### Shared Configuration

These apply to ALL hosts:
- `configuration.nix` - Core system settings
- `modules/*.nix` - System-wide features
- `home/*.nix` - User environment

### Host-Specific Configuration

Edit files in `hosts/<hostname>/` to customize per-machine:

**Desktop-specific** (iron-tower):
- Multi-monitor setup
- Desktop GPU configuration
- High-performance settings

**Laptop-specific** (iron-zephyrus):
- Battery management
- GPU switching (PRIME)
- Power profiles
- Touchpad settings
- Backlight control

## Configuration Testing

Always test before applying:

```bash
# Test build without activating
sudo nixos-rebuild build --flake .#iron-tower

# Apply temporarily (doesn't add boot entry)
sudo nixos-rebuild test --flake .#iron-tower

# If successful, switch permanently
sudo nixos-rebuild switch --flake .#iron-tower
```

## Troubleshooting Multi-Host Setup

### Wrong Host Name

If the build fails with "hostname not found":

```bash
# Check current hostname
hostname

# Update to match flake configuration
sudo hostnamectl set-hostname iron-tower
# or
sudo hostnamectl set-hostname iron-zephyrus

# Or specify explicitly in rebuild
sudo nixos-rebuild switch --flake .#iron-tower
```

### Hardware Configuration Issues

If you get hardware errors after building:

1. Regenerate hardware config:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
   ```

2. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#$(hostname)
   ```

### ASUS Laptop Issues (iron-zephyrus)

**GPU not switching:**
```bash
# Check supergfxctl status
supergfxctl -g

# Switch modes
supergfxctl -m Integrated  # Battery saving
supergfxctl -m Hybrid      # Auto-switching
supergfxctl -m Nvidia      # Always NVIDIA
```

**NVIDIA not available:**
```bash
# Check if driver loaded
lsmod | grep nvidia

# Check bus IDs are correct
lspci | grep -E "(VGA|3D)"

# Update prime.amdgpuBusId and prime.nvidiaBusId in hosts/iron-zephyrus/configuration.nix
```

**Battery charging threshold not working:**
```bash
# Check ASUS daemon status
systemctl status asusd

# Manually set charging threshold
asusctl -c 80
```

## Adding a New Host

To add another machine to this configuration:

### 1. Create Host Directory

```bash
mkdir -p hosts/new-hostname
```

### 2. Create Configuration

```bash
# Create base configuration
cat > hosts/new-hostname/configuration.nix << 'EOF'
{ config, pkgs, ... }:

{
  networking.hostName = "new-hostname";
  time.timeZone = "America/New_York";
  
  # Add host-specific settings here
}
EOF
```

### 3. Generate Hardware Config

```bash
# On the new machine
sudo nixos-generate-config --show-hardware-config > hosts/new-hostname/hardware-configuration.nix
```

### 4. Add to Flake

Edit `flake.nix` and add a new entry in `nixosConfigurations`:

```nix
new-hostname = nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ./configuration.nix
    ./hosts/new-hostname/configuration.nix
    ./hosts/new-hostname/hardware-configuration.nix
    # ... (same modules as other hosts)
  ];
};
```

### 5. Build

```bash
sudo nixos-rebuild switch --flake .#new-hostname
```

## Maintenance Commands

```bash
# Update all flake inputs
nix flake update

# Check flake for errors
nix flake check

# Show flake outputs (list all hosts)
nix flake show

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Clean old generations
sudo nix-collect-garbage -d

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## Best Practices

1. **Always commit before rebuilding**: Keep your configuration in Git
2. **Test on one machine first**: Test changes on iron-tower before applying to iron-zephyrus
3. **Use branches for experiments**: Create Git branches for major changes
4. **Document host-specific changes**: Add comments explaining why settings differ per-host
5. **Keep hardware configs updated**: Regenerate after hardware changes
6. **Sync regularly**: Push/pull changes to keep machines in sync

## Configuration Philosophy

- **Shared by default**: Most configuration is shared between hosts
- **Customize when needed**: Only add host-specific settings when truly different
- **Version control everything**: Track all changes in Git
- **Document differences**: Explain why hosts differ in comments

## Waybar Battery Module

The Waybar configuration includes a battery module that:
- **Desktop (iron-tower)**: Won't display (no battery detected)
- **Laptop (iron-zephyrus)**: Shows battery status, charge level, and time remaining

No configuration changes needed - it auto-detects the battery.
