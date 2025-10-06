# Hardware configuration for iron-tower (Desktop)
# This file should be generated on the actual machine with:
# sudo nixos-generate-config --show-hardware-config > hosts/iron-tower/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # PLACEHOLDER - Generate this file on the actual hardware
  # After installing NixOS, run:
  #   sudo nixos-generate-config --show-hardware-config > hosts/iron-tower/hardware-configuration.nix
  
  # Example configuration (replace with actual):
  # boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # boot.kernelModules = [ "kvm-amd" ]; # or "kvm-intel"
  
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
  #   fsType = "ext4";
  # };
  
  # Boot loader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
