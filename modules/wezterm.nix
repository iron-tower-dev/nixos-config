{ config, pkgs, ... }:

{
  # WezTerm terminal emulator
  environment.systemPackages = with pkgs; [
    wezterm
  ];

  # WezTerm is primarily configured through home-manager
  # See home/wezterm.nix for the full configuration
}
