{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel for gaming and hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters for gaming and performance
  boot.kernelParams = [
    "quiet"
    "splash"
    "nowatchdog"
    "kernel.nmi_watchdog=0"
  ];

  # Enable Plymouth for beautiful boot splash
  boot.plymouth.enable = true;

  # Bootloader timeout
  boot.loader.timeout = 5;
}
