{ config, pkgs, ... }:

{
  # Stylix - System-wide theming from wallpaper
  stylix = {
    enable = true;
    
    # Set your wallpaper path here
    # Using local wallpaper from wallpapers directory (works in VMs too!)
    image = ../wallpapers/flower-field-3.png;
    
    # Alternative wallpapers available:
    # image = ../wallpapers/nix-snowflake-dark.png;     # Dark gray theme
    # image = ../wallpapers/nix-geometric.png;          # Geometric design
    # image = ../wallpapers/solid-dark.png;             # Solid color (VM-friendly)
    
    # Base16 scheme (optional - Stylix will generate from image if not set)
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    
    # Polarity - can be "dark" or "light"
    polarity = "dark";
    
    # Cursor theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    
    # Fonts configuration
    fonts = {
      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
      
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 10;
        popups = 11;
      };
    };
    
    # Opacity settings
    opacity = {
      terminal = 0.9;
      applications = 1.0;
      desktop = 1.0;
      popups = 0.95;
    };
    
    # Target applications - Stylix will theme these automatically
    targets = {
      # Console
      console.enable = true;
      
      # GRUB bootloader
      grub.enable = true;
      
      # GTK
      gtk.enable = true;
      
      # Hyprland (if not using home-manager for this)
      # hyprland.enable = true;
      
      # Rofi - target not available in current Stylix version
      # rofi.enable = true;
    };
  };

  # Additional theming packages
  environment.systemPackages = with pkgs; [
    # Icon themes
    papirus-icon-theme
    
    # Cursor themes
    bibata-cursors
    
    # GTK themes (Stylix will apply colors, but these provide structure)
    adw-gtk3
    
    # Qt theming
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  # GTK theme configuration
  programs.dconf.enable = true;

  # Qt theming handled automatically by Stylix
}
