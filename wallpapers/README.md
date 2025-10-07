# Wallpapers Directory

This directory contains wallpapers that are always available in the nixos-config repository, ensuring Stylix theme generation works even in VMs or minimal environments.

## Available Wallpapers

### NixOS Official Wallpapers
- `nix-snowflake-blue.png` - NixOS blue snowflake wallpaper
- `nix-snowflake-dark.png` - NixOS dark gray snowflake wallpaper  
- `nix-snowflake-light.png` - NixOS light gray snowflake wallpaper
- `nix-geometric.png` - NixOS geometric dark wallpaper

### Solid Colors
- `solid-dark.png` - Solid dark background (#2e3440) - great for VMs and minimal setups

## Usage in Stylix Configuration

You can reference these wallpapers in your `modules/stylix.nix`:

```nix
stylix = {
  enable = true;
  
  # Use a local wallpaper
  image = ./wallpapers/nix-snowflake-blue.png;
  
  # Or for VMs, use the solid color for reliable theming
  # image = ./wallpapers/solid-dark.png;
  
  polarity = "dark";
  # ... other settings
};
```

## Benefits

- **Reliability**: No network dependencies for wallpaper downloads
- **VM-friendly**: Works in isolated environments without internet
- **Consistent**: Same wallpapers across all builds and machines
- **Fast**: No download time during builds

## Adding New Wallpapers

To add new wallpapers:
1. Add the image file to this directory
2. Update this README
3. Commit the changes to git
4. Reference in `modules/stylix.nix`