{ config, lib, pkgs, ... }:

{
  # Define your hostname
  networking.hostName = "nixos"; # Change this to your desired hostname

  # Enable networking
  networking.networkmanager.enable = true;

  # Wireless support via iwd (faster than wpa_supplicant)
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # DNS configuration
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Enable IPv6
  networking.enableIPv6 = true;
}
