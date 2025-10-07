{ config, pkgs, ... }:

{
  # Rofi - Application launcher and menu system
  environment.systemPackages = with pkgs; [
    # Rofi for Wayland
    rofi-wayland
    
    # Additional rofi utilities
    rofi-calc
    rofi-emoji
    rofi-bluetooth
    rofi-power-menu
    
    # For custom scripts
    jq
    
    # System update tools
    nix
    
    # Power management
    systemd
  ];

  # Rofi configuration is handled entirely by Home Manager
  # System module only provides packages and scripts

  # Create system scripts for Rofi menus
  environment.systemPackages = [
    (pkgs.writeScriptBin "rofi-update" ''
      #!${pkgs.bash}/bin/bash
      
      # Rofi menu for system updates
      choice=$(echo -e "Update System\nUpdate Flake\nGarbage Collect\nCancel" | \
        ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "System Update")
      
      case "$choice" in
        "Update System")
          ${pkgs.wezterm}/bin/wezterm start -- bash -c "cd ~/nixos-config && sudo nixos-rebuild switch --flake .; read"
          ;;
        "Update Flake")
          ${pkgs.wezterm}/bin/wezterm start -- bash -c "cd ~/nixos-config && nix flake update; read"
          ;;
        "Garbage Collect")
          ${pkgs.wezterm}/bin/wezterm start -- bash -c "sudo nix-collect-garbage -d && nix-collect-garbage -d; read"
          ;;
      esac
    '')
    
    (pkgs.writeScriptBin "rofi-power" ''
      #!${pkgs.bash}/bin/bash
      
      # Rofi power menu
      choice=$(echo -e "Shutdown\nReboot\nSuspend\nLock\nLogout\nCancel" | \
        ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "Power Menu")
      
      case "$choice" in
        "Shutdown")
          systemctl poweroff
          ;;
        "Reboot")
          systemctl reboot
          ;;
        "Suspend")
          systemctl suspend
          ;;
        "Lock")
          ${pkgs.hyprlock}/bin/hyprlock
          ;;
        "Logout")
          ${pkgs.hyprland}/bin/hyprctl dispatch exit
          ;;
      esac
    '')
    
    (pkgs.writeScriptBin "rofi-scripts" ''
      #!${pkgs.bash}/bin/bash
      
      # Rofi script launcher
      choice=$(echo -e "Screenshot\nScreen Record\nColor Picker\nUpdate System\nPower Menu\nCancel" | \
        ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "Scripts")
      
      case "$choice" in
        "Screenshot")
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | \
            ${pkgs.wl-clipboard}/bin/wl-copy && \
            ${pkgs.libnotify}/bin/notify-send "Screenshot copied to clipboard"
          ;;
        "Screen Record")
          pkill wf-recorder || ${pkgs.wf-recorder}/bin/wf-recorder -g "$(${pkgs.slurp}/bin/slurp)" -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4
          ;;
        "Color Picker")
          ${pkgs.hyprpicker}/bin/hyprpicker -a
          ;;
        "Update System")
          rofi-update
          ;;
        "Power Menu")
          rofi-power
          ;;
      esac
    '')
  ];
}
