# Hardware configuration for iron-zephyrus (ASUS G14 Zephyrus Laptop)
# This file should be generated on the actual machine with:
# sudo nixos-generate-config --show-hardware-config > hosts/iron-zephyrus/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # PLACEHOLDER - Generate this file on the actual hardware
  # After installing NixOS, run:
  #   sudo nixos-generate-config --show-hardware-config > hosts/iron-zephyrus/hardware-configuration.nix
  
  # Example configuration for ASUS G14 (replace with actual):
  # boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  # boot.kernelModules = [ "kvm-amd" ];
  
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
  #   fsType = "ext4";
  # };
  
  # Boot loader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
