# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is a modular, flake-based NixOS configuration with comprehensive gaming, development, and theming features. The configuration uses Home Manager for user-level settings and provides isolated development shells for multiple programming languages.

## Essential Commands

### Build & Deploy
```fish
# Build without activating (test configuration)
sudo nixos-rebuild build --flake .

# Apply configuration immediately
sudo nixos-rebuild switch --flake .

# Apply configuration on next boot
sudo nixos-rebuild boot --flake .

# Test configuration (doesn't add to boot menu)
sudo nixos-rebuild test --flake .

# Aliases (defined in modules/shells.nix)
nrs        # nixos-rebuild switch --flake .
nrb        # nixos-rebuild boot --flake .
nrt        # nixos-rebuild test --flake .
update     # Full system update from ~/nixos-config
```

### Validation & Testing
```fish
# Check flake for syntax errors
nix flake check

# Show detailed error trace
sudo nixos-rebuild build --flake . --show-trace

# Validate Nix syntax without building
nix-instantiate --parse <file.nix>
```

### Flake Management
```fish
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager

# Show flake metadata
nix flake metadata

# Show flake outputs
nix flake show

# Aliases
nfu        # nix flake update
nfc        # nix flake check
```

### Development Shells
```fish
# Enter language-specific development environments
nix develop .#dotnet      # .NET 8 with OmniSharp
nix develop .#elixir      # Elixir with Erlang and language server
nix develop .#angular     # Node.js 22 with Angular CLI
nix develop .#kotlin      # Kotlin with language server, Gradle, JDK 21
nix develop .#go          # Go with gopls and debugging tools
nix develop .#rust        # Rust with rust-analyzer and clippy
nix develop .#full        # All language toolchains combined

# Development shells are defined in flake.nix outputs.devShells
```

### Maintenance
```fish
# Garbage collection
sudo nix-collect-garbage -d      # Delete old system generations
nix-collect-garbage -d           # Delete old user generations
cleanup                          # Alias for both

# Optimize Nix store
nix-store --optimise

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## Architecture

### Flake Structure
The configuration uses Nix flakes with these key inputs:
- **nixpkgs**: nixos-unstable channel
- **home-manager**: User environment management
- **hyprland**: Wayland compositor
- **stylix**: System-wide theming from wallpaper
- **nix-gaming**: Gaming optimizations
- **nixvim**: Neovim configuration framework

### Module Organization
```
configuration.nix         # Core system config (imports hardware-configuration.nix)
├── modules/             # System-level NixOS modules
│   ├── bootloader.nix   # Systemd-boot, latest kernel
│   ├── networking.nix   # Network configuration, hostname
│   ├── users.nix        # User accounts and groups
│   ├── system.nix       # System packages, fonts
│   ├── gaming.nix       # Steam, Lutris, GameMode, performance tweaks
│   ├── development.nix  # All dev tools, languages, Docker, databases
│   ├── neovim.nix       # Neovim with LSPs for all languages
│   ├── hyprland.nix     # Wayland compositor system config
│   ├── stylix.nix       # Wallpaper-based theming
│   ├── shells.nix       # Bash, Zsh, Fish, aliases
│   ├── security.nix     # Firewall, fail2ban, AppArmor
│   └── performance.nix  # CPU frequency, ZRAM, earlyoom
└── home/                # Home Manager user configurations
    ├── home.nix         # Main home config, user packages
    ├── hyprland.nix     # Hyprland keybindings, window rules
    ├── wezterm.nix      # Terminal emulator config
    ├── fish.nix         # Fish shell configuration
    ├── starship.nix     # Shell prompt customization
    ├── git.nix          # Git and lazygit configuration
    └── rofi.nix         # Application launcher theming
```

### Configuration Flow
1. `flake.nix` defines system configurations and dev shells
2. `nixosConfigurations.nixos` imports `configuration.nix` + all modules
3. Home Manager is integrated as NixOS module (not standalone)
4. Stylix generates colors from wallpaper and applies to all applications
5. User configs in `home/` customize applications at user level

## Critical Patterns

### Making Changes

**System-level changes** (affects all users, system services):
- Edit files in `modules/`
- Add to `environment.systemPackages`
- Rebuild with `sudo nixos-rebuild switch --flake .`

**User-level changes** (personal apps, dotfiles):
- Edit files in `home/`
- Add to `home.packages` in `home/home.nix`
- Rebuild triggers both system and home-manager

**Adding new modules**:
1. Create `.nix` file in `modules/` or `home/`
2. Import in `flake.nix` (for system) or `home/home.nix` (for user)
3. Follow existing module patterns with `{ config, pkgs, ... }:`

### Development Environment Pattern

The configuration provides **two strategies** for development environments:

1. **Global devshells** (in `flake.nix`): Use for quick access to toolchains
2. **Project-specific flakes**: Create `flake.nix` in project directory + use direnv for automatic activation

When adding support for new languages:
- Add packages to `modules/development.nix` (system-wide availability)
- Create new devshell in `flake.nix` outputs (isolated environment)
- Include LSP, formatter, linter, and debugger for the language

### Theming with Stylix

Stylix generates base16 color schemes from `modules/stylix.nix`:
- Change wallpaper: Edit `stylix.image` (local path or fetchurl)
- Get SHA256: `nix-prefetch-url <url>`
- Manual scheme: Set `stylix.base16Scheme` instead of using image
- Toggle light/dark: Set `stylix.polarity`

Stylix automatically themes: console, GRUB, GTK, terminal, Hyprland, Rofi

### User Customization Points

When personalizing this config, update:
- `flake.nix` line 39: hostname
- `modules/networking.nix`: hostname and timezone
- `configuration.nix`: timezone and locale
- `home/home.nix`: username, email
- `modules/users.nix`: default shell, user groups
- `modules/stylix.nix`: wallpaper path

## Language-Specific Notes

### .NET
- SDK: .NET 8 (system-wide in `modules/development.nix`)
- LSP: omnisharp-roslyn
- Telemetry disabled in devshell

### Elixir
- Erlang + Elixir + rebar3 installed
- LSP: elixir-ls
- Mix available in devshells

### Angular/Web
- Node.js 22 with npm, pnpm, yarn
- Angular CLI, TypeScript, Prettier, ESLint
- Memory limit: 4GB (NODE_OPTIONS in `modules/development.nix`)

### Kotlin
- Multiple JDK versions: 21, 17, 11
- Build tools: Gradle, Maven
- LSP: kotlin-language-server

### Go
- gopls, gotools, golangci-lint, delve debugger
- GOPATH: `$HOME/go`

### Rust
- Rust stable via rustc + cargo
- Tools: rust-analyzer, rustfmt, clippy
- CARGO_HOME: `$HOME/.cargo`

## Testing Patterns

When modifying the configuration:

1. **Syntax check first**: `nix flake check`
2. **Build without activating**: `sudo nixos-rebuild build --flake .`
3. **Test if successful**: `sudo nixos-rebuild test --flake .` (temporary, no boot entry)
4. **Commit to system**: `sudo nixos-rebuild switch --flake .`

If a build breaks the system:
- Boot into previous generation from systemd-boot menu
- Or: `sudo nixos-rebuild switch --rollback`

## Hyprland-Specific

This configuration uses Hyprland (Wayland compositor) with custom keybindings:
- Main config: `modules/hyprland.nix` (system-level enablement)
- User config: `home/hyprland.nix` (keybindings, window rules, monitors)

Key points:
- Keybindings use `$mainMod = SUPER`
- Terminal: WezTerm (configured in `home/wezterm.nix`)
- Launcher: Rofi with Wayland support
- Screenshots: Handled via Hyprland + grim/slurp

When modifying Hyprland config, changes only take effect after:
1. Rebuild: `sudo nixos-rebuild switch --flake .`
2. Reload Hyprland: `Super + Shift + R` or restart session

## Common Pitfalls

1. **Forgetting to regenerate hardware-configuration.nix**: This file is hardware-specific and must be generated on each new machine with `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix`

2. **Module conflicts**: The config disables `hardware.pulseaudio` because PipeWire is enabled. Similarly, TLP should not be used alongside auto-cpufreq. Check for conflicting options when adding features.

3. **Flake inputs out of sync**: After updating inputs with `nix flake update`, always rebuild. Inputs are locked in `flake.lock`.

4. **Hostname mismatch**: The flake defines `nixosConfigurations.nixos` (line 39 of flake.nix). This must match your actual hostname, or specify it: `sudo nixos-rebuild switch --flake .#hostname`

5. **Home Manager state version**: Both `system.stateVersion` and `home.stateVersion` should match your first NixOS installation version. Never change these on existing installations.

6. **Unfree packages**: Configuration allows unfree packages via `nixpkgs.config.allowUnfree = true` in configuration.nix. If this is removed, Steam, Discord, and other unfree software will fail to build.

## Direnv Integration

The configuration includes direnv for automatic environment activation:
1. Create `flake.nix` in your project
2. Add `.envrc` with content: `use flake`
3. Run: `direnv allow`
4. Environment activates automatically when entering directory

See `devshells/README.md` for detailed patterns and examples.
