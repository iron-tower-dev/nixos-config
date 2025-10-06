# Hyprland Scripts

Custom scripts for Hyprland window manager.

## hyprland-help.sh

Dynamic keybind help system that displays keyboard shortcuts in Rofi.

### Features

- **Dynamic Parsing**: Reads keybinds directly from running Hyprland instance
- **Auto-Updates**: Changes to keybinds automatically appear in help
- **Categorized Display**: Groups binds by function (Apps, Windows, Workspaces, etc.)
- **Beautiful UI**: Rofi display with icons and formatting
- **Comprehensive**: Includes Waybar interactions, Rofi shortcuts, and tips

### Usage

**Keyboard Shortcut**: `Super + H`

**Command Line**:
```bash
~/.config/hyprland/scripts/hyprland-help.sh
```

### How It Works

1. Connects to Hyprland via `hyprctl binds -j`
2. Parses JSON output to extract keybindings
3. Categorizes and formats each binding
4. Displays in Rofi with custom styling

### Categories Displayed

- 📋 Applications & Windows
- 🪟 Focus & Movement
- 📊 Workspaces
- 📸 Screenshots
- 🔊 Media & Volume
- 💡 Brightness
- ⚙️ System
- 🎨 Waybar Interactions
- 💻 Useful Commands
- 📝 Rofi Shortcuts
- 💡 Tips & Tricks

### Customization

Edit the script to:
- Change categories
- Modify descriptions
- Adjust Rofi styling
- Add custom keybind groups

**Script Location**: `~/nixos-config/home/scripts/hyprland-help.sh`

### Requirements

- Hyprland (running)
- Rofi
- jq (JSON parser)
- JetBrainsMono Nerd Font

All requirements are included in the NixOS configuration.

### Troubleshooting

**Help doesn't open**:
```bash
# Check if script is executable
ls -l ~/.config/hyprland/scripts/hyprland-help.sh

# Test manually
bash ~/.config/hyprland/scripts/hyprland-help.sh
```

**"Cannot connect to Hyprland"**:
- Make sure Hyprland is running
- Check `hyprctl binds` works manually

**Keybinds not showing**:
- Verify jq is installed: `which jq`
- Test Hyprland IPC: `hyprctl binds -j`

### Adding New Scripts

1. Create script in `home/scripts/`
2. Add to `home/hyprland.nix`:
   ```nix
   home.file.".config/hyprland/scripts/your-script.sh" = {
     source = ./scripts/your-script.sh;
     executable = true;
   };
   ```
3. Add keybind in Hyprland settings
4. Rebuild: `sudo nixos-rebuild switch --flake .#$(hostname)`

## Future Scripts

Ideas for additional scripts:
- Window layout switcher
- Workspace organizer
- Screenshot manager
- Quick settings panel
- Power profile switcher
