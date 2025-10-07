{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    
    profiles = {
      default = {
        isDefault = true;
        
        # General settings
        settings = {
          # Privacy and security
          "mail.spam.manualMark" = true;
          "mailnews.mark_message_read.auto" = true;
          "mailnews.mark_message_read.delay.interval" = 5;
          
          # Composition
          "mail.compose.default_to_paragraph" = true;
          "mail.identity.default.compose_html" = true;
          
          # Threading
          "mailnews.default_sort_order" = 2; # Descending
          "mailnews.default_sort_type" = 18; # Date
          
          # Interface
          "mail.pane_config.dynamic" = 1;
          "mailnews.start_page.enabled" = false;
          
          # Calendar integration
          "calendar.integration.notify" = true;
        };
      };
    };
  };

  # Additional Thunderbird-related packages
  home.packages = with pkgs; [
    # Proton Mail Bridge is already in productivity.nix
    # but we can add other mail-related tools here if needed
  ];

  # Optional: Set Thunderbird as default mail client
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "message/rfc822" = [ "thunderbird.desktop" ];
    };
  };

  # Optional: Create a desktop entry for easy Proton Mail Bridge access
  xdg.desktopEntries = {
    protonmail-bridge = {
      name = "Proton Mail Bridge";
      comment = "Proton Mail Bridge for desktop email clients";
      exec = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window";
      icon = "mail-client";
      terminal = false;
      categories = [ "Network" "Email" ];
      startupNotify = true;
    };
  };

  # Optional: Systemd user service for Proton Mail Bridge
  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "Proton Mail Bridge";
      After = [ "graphical-session.target" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window";
      Restart = "on-failure";
      RestartSec = 5;
      # Environment variables if needed
      Environment = [
        "PATH=${pkgs.gnome.gnome-keyring}/bin:$PATH"
      ];
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}