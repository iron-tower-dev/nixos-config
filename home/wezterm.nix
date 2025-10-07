{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- WezTerm configuration
      local wezterm = require 'wezterm'
      local config = {}

      -- Color scheme with explicit colors to fix invisible text
      config.color_scheme = 'Tokyo Night'
      
      -- Force readable colors (fixes Stylix text visibility issues)
      config.colors = {
        foreground = '#c0caf5',
        background = '#1a1b26',
      }

      -- Font configuration
      config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
      config.font_size = 12.0

      -- Window configuration
      config.window_background_opacity = 0.9
      config.window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
      }

      -- Tab bar
      config.enable_tab_bar = true
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = true

      -- Scrollback
      config.scrollback_lines = 10000

      -- Key bindings
      config.keys = {
        { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
        { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
        { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
        { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab{ confirm = true } },
      }

      return config
    '';
  };
}
