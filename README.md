# NixOS Configuration

A modular, flake-based NixOS configuration featuring:
- 🎮 **Comprehensive gaming setup** with Steam, Lutris, and performance optimizations
- 💻 **Full development environment** for .NET, Elixir, Angular, Kotlin, Go, and Rust
- 🎨 **Beautiful Hyprland** with Stylix for wallpaper-based system-wide theming
- 🐚 **Modern shell setup** with Fish, Zsh, Bash, and Starship prompt
- 🚀 **Performance tuning** for optimal system responsiveness
- 🔒 **Security hardening** with firewall, AppArmor, and fail2ban
- 📦 **Development shells** for isolated per-project environments
- 🖥️ **Multi-host support** for desktop (iron-tower) and laptop (iron-zephyrus)

## 🎯 Quick Links

- **New Installation?** → Start with [QUICKSTART.md](QUICKSTART.md) or [INSTALL.md](INSTALL.md)
- **Multiple Machines?** → See [MULTI_HOST_SETUP.md](MULTI_HOST_SETUP.md)
- **GitHub Setup?** → Check [GITHUB_SETUP.md](GITHUB_SETUP.md)
- **Waybar Guide?** → Read [home/WAYBAR_GUIDE.md](home/WAYBAR_GUIDE.md)

## 🖥️ Configured Hosts

### iron-tower (Desktop)
- Full desktop workstation setup
- Gaming and development focused
- Configuration: `hosts/iron-tower/`

### iron-zephyrus (ASUS G14 Zephyrus Laptop)
- Portable gaming and development
- NVIDIA GPU switching (PRIME)
- ASUS-specific optimizations (asusctl, supergfxctl)
- Battery management and power profiles
- Configuration: `hosts/iron-zephyrus/`

## 📁 Project Structure

```
nixos-config/
├── flake.nix                 # Main flake configuration with inputs and devshells
├── configuration.nix         # Core system configuration
├── hardware-configuration.nix # Hardware-specific settings (generate your own)
│
├── modules/                  # System-level NixOS modules
│   ├── bootloader.nix       # Boot configuration with latest kernel
│   ├── networking.nix       # Network settings
│   ├── users.nix            # User account configuration
│   ├── system.nix           # Essential packages and fonts
│   ├── gaming.nix           # Steam, Lutris, Wine, performance tweaks
│   ├── development.nix      # Development tools and languages
│   ├── neovim.nix           # Neovim with LSPs for all languages
│   ├── hyprland.nix         # Hyprland Wayland compositor
│   ├── stylix.nix           # System-wide theming from wallpaper
│   ├── wezterm.nix          # WezTerm terminal
│   ├── shells.nix           # Bash, Zsh, Fish configuration
│   ├── quickshell.nix       # QuickShell/Waybar setup
│   ├── rofi.nix             # Rofi launcher with custom scripts
│   ├── security.nix         # Security hardening
│   └── performance.nix      # Performance optimizations
│
├── home/                     # Home Manager configuration
│   ├── home.nix             # Main home-manager config
│   ├── hyprland.nix         # Hyprland user config with keybindings
│   ├── wezterm.nix          # WezTerm terminal config
│   ├── fish.nix             # Fish shell configuration
│   ├── starship.nix         # Starship prompt
│   ├── git.nix              # Git and lazygit config
│   └── rofi.nix             # Rofi theming
│
└── devshells/                # Development shell documentation
    └── README.md            # Guide for using devshells
```

## 🚀 Quick Start

### 1. Generate Hardware Configuration

First, generate your hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### 2. Update Configuration

Edit the following files to match your setup:

- `flake.nix`: Change hostname from "nixos" to your actual hostname
- `modules/networking.nix`: Set your hostname and timezone
- `configuration.nix`: Adjust timezone and locale
- `home/home.nix`: Update username and email

### 3. Build and Switch

```bash
# Build the configuration (test without activating)
sudo nixos-rebuild build --flake .

# Switch to the new configuration
sudo nixos-rebuild switch --flake .

# Reboot (recommended for first time)
sudo reboot
```

## 🎨 Customizing Theming

This configuration uses **Stylix** for system-wide theming based on your wallpaper.

### Change Wallpaper

Edit `modules/stylix.nix`:

```nix
# Use a local wallpaper
image = /home/derrick/Pictures/wallpapers/my-wallpaper.png;

# Or download one
image = pkgs.fetchurl {
  url = "https://example.com/wallpaper.png";
  sha256 = "sha256-...";
};
```

To get the SHA256 hash:
```bash
nix-prefetch-url https://example.com/wallpaper.png
```

### Manual Theme Selection

Instead of generating colors from wallpaper, use a pre-made base16 scheme:

```nix
base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
```

Browse schemes at: https://github.com/tinted-theming/base16-schemes

### Light vs Dark Mode

Change polarity in `modules/stylix.nix`:

```nix
polarity = "light";  # or "dark"
```

## 🛠️ Development Shells

This configuration provides pre-configured development shells for each language.

### Using Global Devshells

Enter a development environment from anywhere:

```bash
cd ~/nixos-config

nix develop .#dotnet      # .NET development
nix develop .#elixir      # Elixir development
nix develop .#angular     # Angular/Web development
nix develop .#kotlin      # Kotlin development
nix develop .#go          # Go development
nix develop .#rust        # Rust development
nix develop .#full        # All languages
```

### Project-Specific Devshells

Create a `flake.nix` in your project directory and use `direnv` for automatic activation.

See `devshells/README.md` for detailed examples and best practices.

## ⚙️ Common Tasks

### Update System

```bash
# From this directory
sudo nixos-rebuild switch --flake .

# Or use the alias (defined in modules/shells.nix)
update
```

### Update Flake Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Then rebuild
sudo nixos-rebuild switch --flake .
```

### Garbage Collection

```bash
# Delete old generations
sudo nix-collect-garbage -d

# Or use the alias
cleanup

# Also optimize the store
nix-store --optimise
```

### Rollback to Previous Generation

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback
sudo nixos-rebuild switch --rollback

# Or at boot: Select previous generation in systemd-boot menu
```

## 🎮 Gaming

Gaming packages and optimizations are in `modules/gaming.nix`.

### Launch Games with GameMode

```bash
gamemoderun %command%
```

Or in Steam: Set launch options to `gamemoderun %command%`

### MangoHud Overlay

Add to Steam launch options:
```
mangohud %command%
```

### Proton Version Management

Install ProtonUp-Qt (already included) to manage Proton versions:
```bash
protonup-qt
```

## 🔧 Hyprland Configuration

### Keybindings (Main)

| Keys | Action |
|------|--------|
| `Super + Return` | Open terminal (WezTerm) |
| `Super + D` | Open application launcher (Rofi) |
| `Super + Q` | Close window |
| `Super + E` | Open file manager |
| `Super + S` | Screenshot (copy to clipboard) |
| `Super + Shift + S` | Screenshot (save to file) |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle floating |

Full keybindings in `home/hyprland.nix`.

### Customize Hyprland

Edit `home/hyprland.nix` for:
- Window gaps and borders
- Animations
- Monitor configuration
- Startup applications

## 📦 Adding Packages

### System-wide Packages

Edit `modules/system.nix` and add to `environment.systemPackages`.

### User Packages

Edit `home/home.nix` and add to `home.packages`.

### Temporary Package

```bash
nix-shell -p package-name
```

## 🔒 Security

Security features are in `modules/security.nix`.

**Enabled by default:**
- Firewall
- Fail2ban
- AppArmor
- Kernel hardening
- Network hardening

**Optional (commented out):**
- SSH hardening (enable if needed)
- USBGuard
- Audit framework
- Secure Boot preparation

### Enable SSH

Edit `modules/security.nix` and set:
```nix
services.openssh.enable = true;
```

## ⚡ Performance

Performance optimizations in `modules/performance.nix`:

- **auto-cpufreq**: Automatic CPU frequency scaling
- **ZRAM**: Compressed swap in RAM
- **earlyoom**: Early OOM killer
- **I/O schedulers**: Optimized for SSDs/NVMe
- **Kernel tuning**: Network and VM optimizations

### Monitor Performance

```bash
btop        # Better htop
nvtop       # GPU monitoring
iotop       # I/O monitoring
```

## 🐚 Shell Configuration

### Default Shell

Fish is set as the default shell. Change in `modules/users.nix`:

```nix
shell = pkgs.bash;  # or pkgs.zsh
```

### Prompt Customization

Starship prompt is configured in `home/starship.nix`. Customize symbols, colors, and modules there.

### Shell Aliases

Common aliases are in `modules/shells.nix`:
- `ls` → `eza`
- `cat` → `bat`
- `nrs` → Rebuild and switch
- `nfu` → Update flake

## 🎯 Neovim

A basic Neovim configuration is in `modules/neovim.nix` with LSPs for all development languages.

For a full IDE-like experience, consider:
- LazyVim
- NvChad
- AstroNvim
- Or configure your own in home-manager

LSPs included for: .NET, Elixir, TypeScript/Angular, Kotlin, Go, Rust, Nix, Bash, Python, and more.

## 🐛 Troubleshooting

### Build Fails

```bash
# Check for syntax errors
nix flake check

# View detailed error
sudo nixos-rebuild build --flake . --show-trace
```

### Missing Hardware Configuration

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### Conflicts Between Modules

Some modules may conflict (e.g., TLP vs auto-cpufreq). Check module files and disable conflicting options.

### Flake Inputs Out of Date

```bash
nix flake update
sudo nixos-rebuild switch --flake .
```

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Stylix Documentation](https://github.com/danth/stylix)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS Discourse](https://discourse.nixos.org/)

## 🤝 Contributing

This is a personal configuration but feel free to:
- Use it as a reference
- Copy modules that interest you
- Suggest improvements via issues
- Share your own configurations

## 📝 License

This configuration is provided as-is for personal use and reference.

## 🙏 Acknowledgments

Built with inspiration from the NixOS community and various dotfiles repositories.

---

**Note:** This configuration is tailored for my setup. You'll need to adjust hostnames, usernames, hardware settings, and personal preferences to match your system.
