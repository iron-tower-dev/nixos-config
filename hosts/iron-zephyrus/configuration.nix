{ config, pkgs, ... }:

{
  # Host-specific configuration for iron-zephyrus (ASUS G14 Zephyrus Laptop)
  
  # Hostname
  networking.hostName = "iron-zephyrus";
  
  # Timezone
  time.timeZone = "America/New_York";
  
  # Laptop-specific settings
  
  # Enable laptop power management
  services.thermald.enable = true;
  
  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };
  
  # Battery optimization
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
    criticalPowerAction = "Hibernate";
  };
  
  # ASUS-specific: Enable support for ASUS ROG laptops (G14 Zephyrus)
  services.supergfxd.enable = true; # For GPU switching on ASUS laptops
  services.asusd = {
    enable = true; # ASUS laptop daemon
    enableUserService = true;
  };
  
  # Enable TLP for advanced power management (alternative to auto-cpufreq)
  # Note: Disable auto-cpufreq in performance.nix if using TLP
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     CPU_BOOST_ON_AC = 1;
  #     CPU_BOOST_ON_BAT = 0;
  #     START_CHARGE_THRESH_BAT0 = 75;
  #     STOP_CHARGE_THRESH_BAT0 = 80;
  #   };
  # };
  
  # Hybrid GPU setup (NVIDIA + AMD/Intel)
  # ASUS G14 typically has AMD iGPU + NVIDIA dGPU
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # Enable for better battery life
    open = false;
    nvidiaSettings = true;
    # Use production driver for G14
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Enable PRIME for hybrid graphics
    prime = {
      # Run `lspci | grep VGA` to find bus IDs
      # Adjust these values based on your specific laptop
      # amdgpuBusId = "PCI:0:0:0";  # AMD iGPU
      # nvidiaBusId = "PCI:1:0:0";  # NVIDIA dGPU
      
      # Choose mode:
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides nvidia-offload command
      };
      # OR use sync mode for always-on NVIDIA:
      # sync.enable = true;
    };
  };
  
  # Video drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Backlight control
  programs.light.enable = true;
  
  # ASUS utilities
  environment.systemPackages = with pkgs; [
    asusctl      # ASUS control utility
    supergfxctl  # GPU switching control
  ];
}
