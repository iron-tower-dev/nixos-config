{ config, pkgs, ... }:

{
  # Define a user account
  users.users.derrick = {
    isNormalUser = true;
    description = "Derrick";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "audio" 
      "video" 
      "input" 
      "libvirtd" 
      "docker" 
      "gamemode"
    ];
    shell = pkgs.fish;
  };

  # Enable fish as a system shell
  programs.fish.enable = true;
}
