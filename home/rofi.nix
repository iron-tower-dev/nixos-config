{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    # No manual theme - let Stylix handle theming automatically
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
