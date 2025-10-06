# This is a template hardware configuration file.
# Generate your actual hardware-configuration.nix by running:
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ ];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/XXXX-XXXX";
  #   fsType = "vfat";
  # };

  # swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface.
  # networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
