{ config, pkgs, ... }:

{
  # Auto CPU frequency scaling
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Alternative: TLP for laptop power management (disable if using auto-cpufreq)
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
  #     
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 60;
  #   };
  # };

  # Power management tools
  services.power-profiles-daemon.enable = false;  # Conflicts with auto-cpufreq and TLP
  services.upower.enable = true;  # Battery monitoring

  # Enable ZRAM for compressed swap in RAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;  # Use 50% of RAM for ZRAM
  };

  # Early OOM (Out of Memory) killer
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;  # Start killing at 5% free memory
    freeSwapThreshold = 10;
    enableNotifications = true;
  };

  # IRQ balance for better interrupt handling
  services.irqbalance.enable = true;

  # I/O schedulers for better disk performance
  services.udev.extraRules = ''
    # Set scheduler for NVMe
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
    # Set scheduler for SSDs
    ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    # Set scheduler for HDDs
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';

  # System monitoring and performance tools
  environment.systemPackages = with pkgs; [
    # System monitoring
    htop
    btop
    bottom
    nvtop  # GPU monitoring
    iotop
    iftop
    nethogs
    powertop
    
    # Performance profiling
    perf-tools
    linuxPackages.perf
    
    # Benchmarking
    sysbench
    stress
    stress-ng
    
    # Disk tools
    smartmontools
    hdparm
    
    # Network performance
    iperf3
    speedtest-cli
    
    # Process management
    psmisc
    procps
    
    # Temperature monitoring
    lm_sensors
  ];

  # Enable smartd for disk monitoring
  services.smartd = {
    enable = true;
    autodetect = true;
  };

  # Prelink for faster application startup (optional)
  # Note: Can cause issues with some applications
  # services.prelink.enable = true;

  # Tmpfs for /tmp (faster temporary files)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  # Optimize boot time
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Performance tuning via sysctl (in addition to those in gaming.nix)
  boot.kernel.sysctl = {
    # I/O scheduling
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;
    
    # Network performance
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 67108864";
    "net.ipv4.tcp_wmem" = "4096 65536 67108864";
    
    # File handles
    "fs.file-max" = 2097152;
  };

  # Enable fstrim for SSD maintenance
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Performance monitoring daemon
  services.sysstat.enable = true;

  # Optimize Nix store
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Faster builds
  nix.settings = {
    max-jobs = "auto";
    cores = 0;  # Use all cores
    
    # Build users
    # max-jobs = 8;  # Adjust based on your CPU
    
    # Binary cache
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    
    # Experimental features for better performance
    experimental-features = [ "nix-command" "flakes" ];
    
    # Keep build outputs for faster rebuilds
    keep-outputs = true;
    keep-derivations = true;
  };
}
