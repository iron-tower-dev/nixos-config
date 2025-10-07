{ config, pkgs, lib, ... }:

{
  # Install help script
  home.file.".config/hyprland/scripts/hyprland-help.sh" = {
    source = ./scripts/hyprland-help.sh;
    executable = true;
  };
  
  # Install wallpaper script with Stylix image path
  home.file.".config/hyprland/scripts/set-wallpaper.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Set wallpaper using swww
      sleep 1
      swww img "${config.stylix.image}" --transition-type fade --transition-duration 2
    '';
    executable = true;
  };
  
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
      monitor = [
        ",preferred,auto,1"
      ];

      # Startup applications
      exec-once = [
        "swww-daemon"
        "~/.config/hyprland/scripts/set-wallpaper.sh"
        "waybar"
        "mako"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decorations
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        # Shadow options removed (deprecated in newer Hyprland)
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Gestures
      gestures = {
        # workspace_swipe option removed (deprecated)
      };

      # Misc settings
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      # Key bindings
      "$mod" = "SUPER";
      
      bind = [
        # Applications
        "$mod, RETURN, exec, wezterm"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating,"
        "$mod, D, exec, rofi -show drun"
        "$mod, H, exec, ~/.config/hyprland/scripts/hyprland-help.sh"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        
        # Screenshots
        "$mod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"
        
        # Reload wallpaper
        "$mod SHIFT, W, exec, ~/.config/hyprland/scripts/set-wallpaper.sh"
        
        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        
        # Fullscreen
        "$mod, F, fullscreen, 0"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Laptop lid switch
      bindl = [
        ",switch:Lid Switch, exec, systemctl suspend"
      ];
      
      # Media keys
      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
    };
    
    # Extra configuration for border colors
    extraConfig = ''
      # Border colors
      general {
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
      }
    '';
  };
}
