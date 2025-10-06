{ config, pkgs, ... }:

{
  # Host-specific configuration for iron-tower (Desktop)
  
  # Hostname
  networking.hostName = "iron-tower";
  
  # Timezone
  time.timeZone = "America/New_York";
  
  # Desktop-specific settings
  
  # AMD Radeon RX 7800 XT Configuration
  # Enable AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # AMD GPU settings
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    
    # Additional AMD packages
    extraPackages = with pkgs; [
      amdvlk           # AMD Vulkan driver
      rocmPackages.clr # ROCm for compute
    ];
    
    # 32-bit support for gaming
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  }
  
  # Enable hardware video acceleration
  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];
  
  # AMD-specific kernel modules
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # Desktop GPU tools
  environment.systemPackages = with pkgs; [
    # AMD monitoring and control
    radeontop        # AMD GPU monitor
    lact             # Linux AMDGPU Control Application
    
    # GPU info tools
    clinfo           # OpenCL info
    vulkan-tools     # Vulkan utilities
    glxinfo          # OpenGL info
  ];
  
  # Enable corectrl for GPU overclocking (optional)
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff"; # Enable all GPU features
    };
  };
  
  # Multiple monitors support
  # Monitor configuration should be in home/hyprland.nix
}
