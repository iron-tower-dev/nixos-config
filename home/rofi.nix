{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    # Simple dark theme (Stylix rofi target not available)
    theme = "Monokai";
    terminal = "${pkgs.wezterm}/bin/wezterm";
    
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window ";
      display-ssh = "   SSH ";
      sidebar-mode = true;
    };
  };
}
