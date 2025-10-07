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
  services.spice-vdagentd.enable = true; # For SPICE display protocol
  
  # Optimize for virtual hardware
  boot.kernelParams = [
    "elevator=noop"  # VM disk scheduler optimization
    "clocksource=kvm-clock"  # Better time sync in VMs
  ];
  
  # Faster boot for testing
  boot.loader.timeout = 1;
  
  # Disable unnecessary services for VMs to speed up boot
  services.thermald.enable = lib.mkForce false;
  powerManagement.enable = lib.mkDefault false;
  
  # Enable virtio drivers for better performance
  boot.initrd.availableKernelModules = [ 
    "virtio_pci" 
    "virtio_blk" 
    "virtio_scsi" 
    "virtio_net"
    "9p"
    "9pnet_virtio"
  ];
  
  # Graphics for VM (use lightweight option)
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
  
  # Enable 3D acceleration for VMs (works with most hypervisors)
  hardware.opengl = {
    enable = true;
    driSupport = true;
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
  
  # Enable serial console for debugging
  boot.kernelParams = [ "console=ttyS0,115200" "console=tty1" ];
  
  # VM memory optimization - enable ZRAM for better memory usage
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  
  # Disable some performance-heavy features for smoother VM experience
  # Override gaming module settings if needed
  # programs.gamemode.enable = lib.mkForce false;
  
  # Network optimization for VMs
  networking.interfaces = lib.mkDefault {
    # VM typically uses NAT or bridged networking
  };
  
  # Enable SSH for easy access to VM
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # For easier VM testing
    };
  };
  
  # Automatic login for testing convenience (optional - less secure)
  # Uncomment if you want auto-login for testing:
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "derrick";
  # };
}
