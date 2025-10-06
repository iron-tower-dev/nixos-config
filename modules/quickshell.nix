{ config, pkgs, ... }:

{
  # QuickShell - QML-based Wayland bar/widget system
  # Note: QuickShell is relatively new and may need manual configuration
  # This module provides the package and dependencies
  
  environment.systemPackages = with pkgs; [
    # QuickShell (if available in nixpkgs, otherwise needs to be built)
    # quickshell  # Uncomment if available
    
    # Dependencies for system widgets
    # Media controls
    playerctl
    
    # System monitoring
    btop
    htop
    
    # Network management
    networkmanager
    networkmanagerapplet
    
    # Audio
    pavucontrol
    pamixer
    
    # Brightness
    brightnessctl
    
    # Power management
    acpi
    
    # System tray
    libappindicator
    
    # Icon support
    papirus-icon-theme
    
    # Alternative: Use Waybar or AGS instead
    waybar
    eww  # ElKowars wacky widgets
  ];

  # Since QuickShell might not be in nixpkgs yet, consider using Waybar or AGS
  # Waybar configuration is in home-manager
  
  # Enable system services needed for widgets
  services.upower.enable = true;  # Battery info
  
  # Note: Actual QuickShell configuration would go in:
  # ~/.config/quickshell/ or home-manager
  # This includes QML files for:
  # - Media player widget
  # - Workspace indicator
  # - System monitors (CPU, RAM, disk)
  # - Idle inhibitor toggle
  # - Network widget
  # - Clock/calendar
  # - Power menu
}
