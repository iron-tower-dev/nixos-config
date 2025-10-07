{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "derrick";
  home.homeDirectory = "/home/derrick";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # The home.packages option allows you to install Nix packages into your environment
  home.packages = with pkgs; [
    # Web browsers
    firefox
    chromium
    
    # Communication
    # discord - installed via modules/gaming.nix and configured in discord.nix
    slack
    telegram-desktop
    
    # Media
    vlc
    spotify
    
    # Graphics
    gimp
    inkscape
    
    # Office
    libreoffice-fresh
    
    # Notes
    obsidian
    
    # File management
    nautilus
    
    # Archives
    unrar
    p7zip
    
    # Screenshots
    flameshot
  ];

  # Home Manager configuration modules
  imports = [
    # stylix.homeManagerModules.stylix  # Disabled to avoid system-level conflicts
    ./hyprland.nix
    ./waybar.nix
    ./wlogout.nix
    ./discord.nix
    ./wezterm.nix
    ./fish.nix
    ./starship.nix
    ./git.nix
    ./rofi.nix
    ./thunderbird.nix
  ];

  # Git configuration is in ./git.nix
  
  # Direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Bat (cat replacement) - theme handled by Stylix
  programs.bat = {
    enable = true;
    # theme managed by Stylix
  };

  # Zoxide (cd replacement)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # FZF
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # XDG user directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # GTK theming (Stylix will override these)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Qt theming handled at system level in modules/stylix.nix
}
