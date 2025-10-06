#!/usr/bin/env bash

# Hyprland Keybind Help Display
# Dynamically parses keybinds from running Hyprland instance

TEMP_FILE=$(mktemp)

# Function to clean and format keybind display
format_key() {
    local key="$1"
    # Replace common key names with symbols/readable format
    key="${key//SUPER/Super}"
    key="${key//SHIFT/Shift}"
    key="${key//CTRL/Ctrl}"
    key="${key//ALT/Alt}"
    key="${key//RETURN/Enter}"
    key="${key//mouse:272/Left Click}"
    key="${key//mouse:273/Right Click}"
    key="${key//mouse_down/Scroll Down}"
    key="${key//mouse_up/Scroll Up}"
    
    # Format arrows
    key="${key//left/←}"
    key="${key//right/→}"
    key="${key//up/↑}"
    key="${key//down/↓}"
    
    echo "$key"
}

# Function to categorize and describe actions
describe_action() {
    local action="$1"
    case "$action" in
        *wezterm*|*terminal*|*kitty*|*alacritty*)
            echo "Terminal" ;;
        *rofi*drun*)
            echo "App Launcher" ;;
        *nautilus*|*thunar*|*dolphin*)
            echo "File Manager" ;;
        *firefox*|*chromium*|*brave*)
            echo "Browser" ;;
        *discord*)
            echo "Discord" ;;
        *thunderbird*)
            echo "Email" ;;
        *1password*)
            echo "Password Manager" ;;
        killactive*)
            echo "Close Window" ;;
        togglefloating*)
            echo "Toggle Floating" ;;
        fullscreen*)
            echo "Fullscreen" ;;
        exit*)
            echo "Exit Hyprland" ;;
        pseudo*)
            echo "Pseudo-tile" ;;
        togglesplit*)
            echo "Toggle Split" ;;
        movefocus*)
            echo "Move Focus" ;;
        workspace,*[0-9])
            echo "Switch Workspace" ;;
        movetoworkspace*)
            echo "Move to Workspace" ;;
        workspace,e+1)
            echo "Next Workspace" ;;
        workspace,e-1)
            echo "Previous Workspace" ;;
        *grim*slurp*wl-copy*)
            echo "Screenshot → Clipboard" ;;
        *grim*slurp*Pictures*)
            echo "Screenshot → File" ;;
        movewindow*)
            echo "Move Window" ;;
        resizewindow*)
            echo "Resize Window" ;;
        *pamixer*-i*)
            echo "Volume Up" ;;
        *pamixer*-d*)
            echo "Volume Down" ;;
        *pamixer*-t*)
            echo "Mute/Unmute" ;;
        *playerctl*play-pause*)
            echo "Play/Pause" ;;
        *playerctl*next*)
            echo "Next Track" ;;
        *playerctl*previous*)
            echo "Previous Track" ;;
        *brightnessctl*+*)
            echo "Brightness Up" ;;
        *brightnessctl*-*)
            echo "Brightness Down" ;;
        *suspend*)
            echo "Suspend" ;;
        *hyprland-help*)
            echo "Show Help (This)" ;;
        *)
            echo "${action:0:50}" ;;
    esac
}

# Parse keybinds from Hyprland
parse_hyprland_binds() {
    local binds=$(hyprctl binds -j 2>/dev/null)
    
    if [ -z "$binds" ] || [ "$binds" == "null" ]; then
        echo "⚠️  Cannot connect to Hyprland"
        echo ""
        echo "Make sure Hyprland is running or view the config at:"
        echo "~/nixos-config/home/hyprland.nix"
        return 1
    fi
    
    # Parse JSON and format output
    echo "$binds" | jq -r '.[] | 
        select(.locked == false) | 
        "\(.modmask)|\(.key)|\(.dispatcher)|\(.arg)"' | \
    while IFS='|' read -r modmask key dispatcher arg; do
        # Convert modmask to readable format
        local mods=""
        [ $((modmask & 64)) -ne 0 ] && mods+="SUPER+"
        [ $((modmask & 1)) -ne 0 ] && mods+="SHIFT+"
        [ $((modmask & 4)) -ne 0 ] && mods+="CTRL+"
        [ $((modmask & 8)) -ne 0 ] && mods+="ALT+"
        
        # Combine key with mods
        local full_key="${mods}${key}"
        local action="${dispatcher},${arg}"
        
        # Format for display
        local formatted_key=$(format_key "$full_key")
        local description=$(describe_action "$action")
        
        # Only show if we have a good description
        if [ "$description" != "$action" ] && [ -n "$description" ]; then
            printf "%-30s %s\n" "$formatted_key" "$description"
        fi
    done
}

# Generate help content with categories
generate_help() {
    cat << 'HEADER'
╔══════════════════════════════════════════════════════════════╗
║              HYPRLAND KEYBIND REFERENCE                      ║
║              (Dynamically Generated)                         ║
╚══════════════════════════════════════════════════════════════╝

🚀 KEYBOARD SHORTCUTS
──────────────────────────────────────────────────────────────

HEADER

    # Get and categorize binds
    local all_binds=$(parse_hyprland_binds)
    
    if [ $? -eq 0 ]; then
        echo "📋 APPLICATIONS & WINDOWS"
        echo "$all_binds" | grep -E "(Terminal|Launcher|File Manager|Browser|Discord|Email|Password|Close|Floating|Fullscreen|Exit|Pseudo|Split)" | sort -u
        
        echo ""
        echo "🪟 FOCUS & MOVEMENT"
        echo "$all_binds" | grep -E "(Move Focus|Move Window|Resize Window|Move to Workspace)" | sort -u | head -5
        
        echo ""
        echo "📊 WORKSPACES"
        echo "$all_binds" | grep -E "(Switch Workspace|Next Workspace|Previous Workspace)" | sort -u | head -12
        
        echo ""
        echo "📸 SCREENSHOTS"
        echo "$all_binds" | grep "Screenshot" | sort -u
        
        echo ""
        echo "🔊 MEDIA & VOLUME"
        echo "$all_binds" | grep -E "(Volume|Mute|Play|Pause|Track)" | sort -u
        
        echo ""
        echo "💡 BRIGHTNESS"
        echo "$all_binds" | grep "Brightness" | sort -u
        
        echo ""
        echo "⚙️  SYSTEM"
        echo "$all_binds" | grep -E "(Help|Suspend|Exit)" | sort -u
    else
        echo "$all_binds"
    fi
    
    cat << 'FOOTER'

🎨 WAYBAR INTERACTIONS
──────────────────────────────────────────────────────────────
  Click Clock           Toggle Date/Time
  Right-click Clock     Calendar View
  Scroll Volume         Adjust Volume ±5%
  Click Power           Power Menu (wlogout)
  Click Network         Network Settings
  Click Bluetooth       Bluetooth Manager
  Click CPU/RAM         System Monitor (btop)

💻 USEFUL COMMANDS
──────────────────────────────────────────────────────────────
  hyprctl binds        List all keybinds
  hyprctl monitors     List monitors
  hyprctl clients      List windows
  hyprctl reload       Reload config

📝 ROFI SHORTCUTS (When Open)
──────────────────────────────────────────────────────────────
  Esc                   Close
  Enter                 Select/Execute
  Ctrl+Enter            Open in Terminal
  Tab/Shift+Tab         Navigate
  Ctrl+J/K              Navigate (Vim)

💡 TIPS & TRICKS
──────────────────────────────────────────────────────────────
  • Super = Windows/Command key
  • Hold Super + drag to move/resize windows
  • Super + mouse wheel to switch workspaces
  • Middle-click window title to close
  • Hover Waybar modules for tooltips
  • Screenshots auto-copy to clipboard

📚 CONFIGURATION FILES
──────────────────────────────────────────────────────────────
  Hyprland:    ~/nixos-config/home/hyprland.nix
  Waybar:      ~/nixos-config/home/waybar.nix
  README:      ~/nixos-config/README.md
  This Help:   ~/nixos-config/home/scripts/hyprland-help.sh

🔄 Tip: This help is generated from your live Hyprland config!
   Any changes you make will appear here automatically.

FOOTER
}

# Generate and display
generate_help > "$TEMP_FILE"

# Display in Rofi with nice styling
rofi -dmenu \
    -p "  Keybinds & Help" \
    -mesg "Hyprland Keyboard Shortcuts (Press ESC to close)" \
    -theme-str 'window {width: 50%; height: 70%;}' \
    -theme-str 'listview {lines: 30; columns: 1;}' \
    -theme-str 'element-text {font: "JetBrainsMono Nerd Font 10";}' \
    -theme-str 'inputbar {enabled: false;}' \
    -theme-str 'element {padding: 2px;}' \
    < "$TEMP_FILE"

# Clean up
rm -f "$TEMP_FILE"
