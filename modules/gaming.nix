{ config, pkgs, inputs, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Enable GameMode for performance optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    # Gaming platforms
    lutris
    heroic
    bottles
    
    # Performance and monitoring
    mangohud
    goverlay
    gamemode
    gamescope
    
    # Wine and compatibility
    wine
    winetricks
    wine64
    wineWowPackages.stable
    wineWowPackages.staging
    
    # Proton
    protonup-qt
    
    # Game streaming
    sunshine
    
    # Controller support
    antimicrox
    
    # Discord for gaming comms
    discord
    
    # Additional gaming tools
    protontricks
    steamtinkerlaunch
  ];

  # Enable 32-bit graphics drivers for gaming
  hardware.opengl.driSupport32Bit = true;

  # Enable Xbox controller support
  hardware.xone.enable = true;

  # Enable controller support
  hardware.xpadneo.enable = true;

  # Logitech wireless support
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Enable udev rules for controllers
  services.udev.packages = with pkgs; [
    dolphin-emu  # Fixed typo from dolphinEmu
  ];

  # Performance tweaks for gaming
  boot.kernel.sysctl = {
    # Increase file watchers for game launchers
    "fs.inotify.max_user_watches" = 524288;
    
    # Network optimizations
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_mtu_probing" = 1;
    
    # VM tweaks for gaming
    "vm.max_map_count" = 2147483642;
    "vm.swappiness" = 10;
  };

  # Enable BBR TCP congestion control
  boot.kernelModules = [ "tcp_bbr" ];
}
