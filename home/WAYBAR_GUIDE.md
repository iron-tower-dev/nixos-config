# Waybar Configuration Guide

This NixOS configuration includes a modern, sleek Waybar setup with comprehensive system monitoring and control features.

## Features

### 🎨 **Modern Catppuccin-Inspired Design**
- Translucent dark background
- Gradient accents and smooth transitions
- Rounded corners with 8px radius
- Color-coded modules for easy identification
- Hover effects and animations

### 📊 **System Monitoring**
- **CPU Usage**: Click to open btop
- **Memory Usage**: Click to open btop
- **Battery Status**: Shows charge level, charging state, and time remaining
- **Network Status**: WiFi/Ethernet with signal strength

### 🎵 **Media Controls**
- **MPRIS Integration**: Shows currently playing media
- Click to play/pause
- Right-click for next track
- Scroll to navigate tracks
- Supports Spotify, Firefox, Chromium, and more

### 🔊 **Audio Management**
- Volume display with icons
- Click to open pavucontrol
- Right-click to mute/unmute
- Scroll to adjust volume
- Visual indication when muted

### 🔗 **Connectivity**
- **Bluetooth**: Shows connection status and battery levels
  - Click to open Blueman manager
- **Network**: WiFi/Ethernet status with SSID
  - Click to open network settings
  - Hover for detailed connection info

### 🖥️ **Workspace Management**
- Hyprland workspace indicator with custom icons
- Click to switch workspaces
- Visual distinction for active/urgent workspaces
- Shows active window title

### 🕐 **Clock & Calendar**
- Time display (12-hour format)
- Click to toggle date view
- Hover for interactive calendar
- Scroll through months/years

### ⚡ **Power Menu**
- Power button opens wlogout menu
- Options: Lock, Logout, Suspend, Hibernate, Reboot, Shutdown
- Keyboard shortcuts (l/e/u/h/r/s)
- Styled to match Waybar theme

### 📋 **System Tray**
- Shows background applications
- Native tray icon support
- Visual indication for notifications

## Module Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│ [Workspaces] [Window Title]  [Clock]  [Media] [Audio] [BT] [Net]  │
│                                        [CPU] [RAM] [Battery] [Tray] │
│                                                              [Power] │
└─────────────────────────────────────────────────────────────────────┘
```

## Interactions

### Media Player
- **Left Click**: Play/Pause
- **Right Click**: Next track
- **Scroll Up**: Previous track
- **Scroll Down**: Next track

### Volume
- **Left Click**: Open PulseAudio control
- **Right Click**: Mute/Unmute
- **Scroll Up**: Increase volume by 5%
- **Scroll Down**: Decrease volume by 5%

### Bluetooth
- **Left Click**: Open Bluetooth manager

### Network
- **Left Click**: Open network connection editor
- **Hover**: View connection details

### CPU/Memory
- **Left Click**: Open btop system monitor

### Clock
- **Left Click**: Toggle date/time display
- **Right Click**: Change calendar view mode
- **Scroll**: Navigate calendar

### Power Button
- **Left Click**: Open power menu

## Color Scheme

The Waybar uses a Catppuccin Mocha-inspired color palette:

- **Background**: Translucent dark gray (rgba(30, 30, 46, 0.95))
- **Active Workspace**: Blue gradient (#89b4fa → #b4befe)
- **Media**: Light blue (rgba(137, 180, 250, 0.2))
- **Audio**: Green (rgba(166, 227, 161, 0.2))
- **Bluetooth**: Cyan (rgba(116, 199, 236, 0.2))
- **Network**: Teal (rgba(148, 226, 213, 0.2))
- **CPU**: Yellow (rgba(249, 226, 175, 0.2))
- **Memory**: Pink (rgba(245, 194, 231, 0.2))
- **Battery**: Green (rgba(166, 227, 161, 0.2))
- **Power**: Red (rgba(243, 139, 168, 0.2))

## Configuration Files

- **Main Config**: `home/waybar.nix`
- **Power Menu**: `home/wlogout.nix`
- **Auto-start**: Configured in `home/hyprland.nix`

## Customization

### Change Bar Position
Edit `home/waybar.nix`:
```nix
position = "bottom";  # or "left", "right"
```

### Adjust Bar Height
```nix
height = 40;  # pixels
```

### Modify Module Order
Rearrange the modules in:
```nix
modules-left = [ ... ];
modules-center = [ ... ];
modules-right = [ ... ];
```

### Change Colors
Edit the `style` section in `home/waybar.nix` to customize colors.

### Add/Remove Modules
Comment out or add modules to the `modules-*` arrays and corresponding module definitions.

## Dependencies

All required packages are automatically installed:
- waybar (status bar)
- wlogout (power menu)
- playerctl (media controls)
- pamixer (audio control)
- pavucontrol (audio GUI)
- blueman (Bluetooth manager)
- networkmanagerapplet (network GUI)
- brightnessctl (brightness control)
- btop (system monitor)

## Troubleshooting

### Waybar not appearing
1. Check if it's running: `pgrep waybar`
2. Restart: `killall waybar && waybar &`
3. Check logs: `journalctl --user -u waybar`

### Media controls not working
- Ensure playerctl is installed: `which playerctl`
- Check if a media player is running
- Try: `playerctl status`

### Power menu not opening
- Verify wlogout is installed: `which wlogout`
- Test manually: `wlogout`
- Check configuration: `~/.config/wlogout/`

### Icons not displaying
- Ensure Nerd Fonts are installed (JetBrainsMono Nerd Font)
- Font is configured in `modules/stylix.nix`

### Battery module not showing
- Only displays on laptops with battery
- Comment out the battery module if on desktop

## Reload Configuration

After making changes:
```bash
# Rebuild the system
sudo nixos-rebuild switch --flake .

# Restart Waybar
killall waybar
# Waybar will auto-restart via systemd

# Or manually
waybar &
```

## Additional Resources

- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar Configuration](https://github.com/Alexays/Waybar/wiki/Configuration)
- [Wlogout Documentation](https://github.com/ArtsyMacaw/wlogout)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
