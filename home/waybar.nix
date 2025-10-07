{ config, pkgs, ... }:

{
  # XDG portal settings for Waybar
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };
  
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;
        
        # Module order
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        
        modules-center = [
          "clock"
        ];
        
        modules-right = [
          "mpris"
          "pulseaudio"
          "bluetooth"
          "network"
          "cpu"
          "memory"
          "battery"
          "tray"
          "custom/power"
        ];
        
        # Hyprland workspaces
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            "10" = "󰿬";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };
        
        # Active window title
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };
        
        # Clock with calendar
        clock = {
          interval = 1;
          format = "{:%I:%M %p}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        # Media player (MPRIS)
        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "🎵";
            spotify = "";
            firefox = "";
            chromium = "";
          };
          status-icons = {
            playing = "▶";
            paused = "⏸";
            stopped = "⏹";
          };
          dynamic-order = ["artist" "title"];
          dynamic-importance-order = ["title" "artist"];
          dynamic-len = 40;
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-scroll-up = "playerctl previous";
          on-scroll-down = "playerctl next";
        };
        
        # Audio
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡏";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          on-click-right = "pamixer -t";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          tooltip-format = "{desc} | {volume}%";
        };
        
        # Bluetooth
        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {num_connections}";
          format-connected-battery = " {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };
        
        # Network
        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀 Wired";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "󰈀 {ifname} via {gwaddr}";
          tooltip-format-wifi = "  {essid} ({signalStrength}%)\n{ipaddr} | {frequency}MHz";
          tooltip-format-ethernet = "󰈀 {ifname}\n{ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
          interval = 5;
        };
        
        # CPU
        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip-format = "CPU Usage: {usage}%\n{avg_frequency}GHz";
          on-click = "wezterm -e btop";
        };
        
        # Memory
        memory = {
          interval = 5;
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}GB / {total:0.1f}GB ({percentage}%)\nSwap: {swapUsed:0.1f}GB / {swapTotal:0.1f}GB";
          on-click = "wezterm -e btop";
        };
        
        # Battery
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-full = "󱈑 {capacity}%";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo}\n{power}W";
        };
        
        # System tray
        tray = {
          icon-size = 18;
          spacing = 10;
        };
        
        # Power menu
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };
    
    # Modern, sleek styling
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
      
      /* Animations */
      @keyframes blink {
        0%%, 100%% { opacity: 1; }
        50%% { opacity: 0.5; }
      }
      
      @keyframes pulse {
        0%%, 100%% { opacity: 1; }
        50%% { opacity: 0.7; }
      }
      
      window#waybar {
        background: rgba(30, 30, 46, 0.95);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
      }
      
      /* Workspace buttons */
      #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: #6c7086;
        border-radius: 8px;
        margin: 4px 2px;
        transition: all 0.3s ease;
      }
      
      #workspaces button:hover {
        background: rgba(108, 112, 134, 0.2);
        color: #cdd6f4;
      }
      
      #workspaces button.active {
        background: linear-gradient(45deg, #89b4fa, #b4befe);
        color: #1e1e2e;
        font-weight: bold;
      }
      
      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
        animation: blink 1s ease infinite;
      }
      
      /* Window title */
      #window {
        padding: 0 12px;
        color: #94e2d5;
        font-weight: normal;
      }
      
      /* Clock */
      #clock {
        padding: 0 16px;
        background: linear-gradient(45deg, #89b4fa, #b4befe);
        color: #1e1e2e;
        border-radius: 8px;
        margin: 4px 0;
        font-weight: bold;
      }
      
      /* Media player */
      #mpris {
        padding: 0 12px;
        background: rgba(137, 180, 250, 0.2);
        color: #89b4fa;
        border-radius: 8px;
        margin: 4px 4px 4px 0;
      }
      
      #mpris.paused {
        color: #6c7086;
      }
      
      /* Audio */
      #pulseaudio {
        padding: 0 12px;
        background: rgba(166, 227, 161, 0.2);
        color: #a6e3a1;
        border-radius: 8px;
        margin: 4px;
      }
      
      #pulseaudio.muted {
        color: #f38ba8;
      }
      
      /* Bluetooth */
      #bluetooth {
        padding: 0 12px;
        background: rgba(116, 199, 236, 0.2);
        color: #74c7ec;
        border-radius: 8px;
        margin: 4px;
      }
      
      #bluetooth.disabled {
        color: #6c7086;
      }
      
      /* Network */
      #network {
        padding: 0 12px;
        background: rgba(148, 226, 213, 0.2);
        color: #94e2d5;
        border-radius: 8px;
        margin: 4px;
      }
      
      #network.disconnected {
        color: #f38ba8;
      }
      
      /* CPU */
      #cpu {
        padding: 0 12px;
        background: rgba(249, 226, 175, 0.2);
        color: #f9e2af;
        border-radius: 8px;
        margin: 4px;
      }
      
      /* Memory */
      #memory {
        padding: 0 12px;
        background: rgba(245, 194, 231, 0.2);
        color: #f5c2e7;
        border-radius: 8px;
        margin: 4px;
      }
      
      /* Battery */
      #battery {
        padding: 0 12px;
        background: rgba(166, 227, 161, 0.2);
        color: #a6e3a1;
        border-radius: 8px;
        margin: 4px;
      }
      
      #battery.charging {
        color: #a6e3a1;
        animation: pulse 2s ease infinite;
      }
      
      #battery.warning:not(.charging) {
        background: rgba(249, 226, 175, 0.3);
        color: #f9e2af;
      }
      
      #battery.critical:not(.charging) {
        background: #f38ba8;
        color: #1e1e2e;
        animation: blink 1s ease infinite;
      }
      
      /* System tray */
      #tray {
        padding: 0 12px;
        background: rgba(108, 112, 134, 0.2);
        border-radius: 8px;
        margin: 4px;
      }
      
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        animation: blink 1s ease infinite;
      }
      
      /* Power menu */
      #custom-power {
        padding: 0 12px;
        background: rgba(243, 139, 168, 0.2);
        color: #f38ba8;
        border-radius: 8px;
        margin: 4px 0 4px 4px;
        font-size: 16px;
      }
      
      #custom-power:hover {
        background: #f38ba8;
        color: #1e1e2e;
      }
      
      /* Tooltips */
      tooltip {
        background: rgba(30, 30, 46, 0.95);
        border: 2px solid #89b4fa;
        border-radius: 8px;
      }
      
      tooltip label {
        color: #cdd6f4;
      }
    '';
  };
  
  # Additional packages for Waybar functionality
  home.packages = with pkgs; [
    # Power menu
    wlogout
    
    # System monitoring
    btop
    
    # Audio control
    pamixer
    pavucontrol
    
    # Media control
    playerctl
    
    # Network management
    networkmanagerapplet
    
    # Bluetooth management
    blueman
    
    # Brightness control
    brightnessctl
  ];
}
