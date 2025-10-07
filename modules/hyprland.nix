{ config, pkgs, inputs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Enable polkit
  security.polkit.enable = true;

  # Polkit authentication agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Hyprland environment variables
  environment.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    
    # XDG
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    
    # QT
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # SDL
    SDL_VIDEODRIVER = "wayland";
    
    # Clutter
    CLUTTER_BACKEND = "wayland";
    
    # GDK
    GDK_BACKEND = "wayland";
  };

  # Hyprland-related packages
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    waybar
    swww  # Wallpaper daemon
    hyprpaper
    hypridle
    hyprlock
    hyprpicker
    
    # Screenshot and screen recording
    grim
    slurp
    swappy
    wf-recorder
    
    # Notification daemon
    mako
    libnotify
    
    # File manager
    nautilus
    
    # Image viewer
    imv
    
    # PDF viewer
    zathura
    
    # Video player
    mpv
    
    # Audio packages moved to modules/audio.nix
    
    # Clipboard manager
    cliphist
    wl-clipboard
    
    # Network manager applet
    networkmanagerapplet
    
    # Brightness control
    brightnessctl
    
    # Additional Wayland tools
    wlr-randr
    wtype
    ydotool
    wayland-utils
    
    # Polkit
    polkit_gnome
  ];

  # Audio configuration moved to modules/audio.nix for reusability

  # Enable greetd display manager with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";  # moved to top-level
        user = "greeter";
      };
    };
  };

  # Enable SDDM as alternative (commented out, enable if preferred)
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };
}
