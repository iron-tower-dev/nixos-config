{ config, pkgs, lib, ... }:

{
  # Host-specific configuration for iron-vm (Virtual Machine for Testing)
  
  # Hostname
  networking.hostName = "iron-vm";
  
  # Timezone
  time.timeZone = "America/New_York";
  
  # VM-specific optimizations
  
  # Enable guest additions for better VM integration
  virtualisation.vmware.guest.enable = lib.mkDefault true;
  virtualisation.virtualbox.guest.enable = lib.mkDefault false;
  
  # QEMU/KVM guest agent for better integration
  services.qemuGuest.enable = true;
  
  # Optimize for virtual hardware
  boot.kernelParams = [
    "elevator=noop"  # VM disk scheduler optimization
    "clocksource=kvm-clock"  # Better time sync in VMs
    "console=ttyS0,115200"  # Serial console for debugging
    "console=tty1"  # TTY console
  ];
  
  # Faster boot for testing
  boot.loader.timeout = 1;
  
  # Disable unnecessary services for VMs to speed up boot
  services.thermald.enable = lib.mkForce false;
  powerManagement.enable = lib.mkDefault false;
  
  # Add VM-specific 9p modules for shared folders (virtio modules from hardware-configuration.nix)
  boot.initrd.availableKernelModules = [ 
    "9p"
    "9pnet_virtio"
  ];
  
  # Graphics for VM (use lightweight option)
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
  
  # Enable graphics acceleration for VMs (works with most hypervisors)
  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkDefault false;  # Disable 32-bit support to save resources in VM
  };
  
  # VM-friendly file system optimizations
  # Disable some file system features that don't work well in VMs
  fileSystems."/".options = [ "noatime" "nodiratime" ];
  
  # Smaller swap for VM (can be adjusted based on allocated RAM)
  swapDevices = lib.mkDefault [ ];
  
  # VM testing tools
  environment.systemPackages = with pkgs; [
    # VM utilities
    open-vm-tools  # VMware tools (if using VMware)
    
    # Testing and debugging
    htop
    iotop
    lsof
    strace
    
    # Quick system checks
    neofetch
    inxi
  ];
  
  # Enable clipboard sharing with host
  services.spice-vdagentd.enable = true;
  
  # Disable gaming-specific features to save resources
  # Note: These will still be loaded from modules, but can be overridden here
  
  # Optional: Reduce resource usage by disabling some features
  # Uncomment these if the VM is too slow:
  # services.udisks2.enable = lib.mkDefault false;
  # services.gnome.gnome-keyring.enable = lib.mkDefault false;
  
  # VM memory optimization - enable ZRAM for better memory usage
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  
  # Disable some performance-heavy features for smoother VM experience
  # Override gaming module settings if needed
  # programs.gamemode.enable = lib.mkForce false;
  
  # VM-specific Stylix optimization - use solid color wallpaper for better performance
  stylix.image = lib.mkForce ../../wallpapers/solid-dark.png;
  
  # Network optimization for VMs
  # VMs typically use NAT or bridged networking configured by the hypervisor
  
  # Enable SSH for easy access to VM
  # WARNING: Password authentication is enabled for ISOLATED TESTING ONLY
  # This is a SECURITY RISK and should NEVER be used in production or on untrusted networks.
  # For real deployments, use key-based authentication by setting PasswordAuthentication = false
  # and configuring users.users.<name>.openssh.authorizedKeys instead.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # TESTING ONLY - change to false for production!
    };
  };
  
  # Automatic login for testing convenience (optional - less secure)
  # Uncomment if you want auto-login for testing:
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "derrick";
  # };
}
