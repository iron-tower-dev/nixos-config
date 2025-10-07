# Hardware configuration for iron-vm (Virtual Machine)
# This file should be generated on the actual VM with:
# sudo nixos-generate-config --show-hardware-config > hosts/iron-vm/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # VM-optimized hardware settings
  boot.initrd.availableKernelModules = [ 
    "ata_piix" 
    "uhci_hcd" 
    "virtio_pci" 
    "virtio_scsi" 
    "sd_mod" 
    "sr_mod" 
    "virtio_blk"
    "virtio_net"
  ];
  
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ]; # Support both AMD and Intel hosts
  boot.extraModulePackages = [ ];

  # File systems - PLACEHOLDER
  # After installing NixOS in the VM, run:
  #   sudo nixos-generate-config --show-hardware-config > hosts/iron-vm/hardware-configuration.nix
  
  # Example configuration (replace with actual after VM installation):
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
  #   fsType = "ext4";
  # };
  
  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/XXXX-XXXX";
  #   fsType = "vfat";
  # };
  
  # swapDevices = [ ];

  # VM typically doesn't need these
  networking.useDHCP = lib.mkDefault true;
  
  # CPU configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  # Enable CPU microcode updates (works for both AMD and Intel)
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
