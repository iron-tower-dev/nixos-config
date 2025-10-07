{ config, pkgs, ... }:

{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    vim
    wget
    curl
    git
    htop
    btop
    neofetch
    fastfetch
    tree
    unzip
    zip
    p7zip
    file
    pciutils
    usbutils
    
    # Modern CLI replacements
    eza        # ls replacement
    fd         # find replacement
    ripgrep    # grep replacement
    bat        # cat replacement
    fzf        # fuzzy finder
    zoxide     # cd replacement
    duf        # df replacement
    dust       # du replacement
    procs      # ps replacement
    
    # System monitoring
    bottom
    bandwhich
    
    # Network tools
    nmap
    speedtest-cli
    
    # Other essentials
    gnumake
    cmake
    gcc
    clang
  ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable location services
  services.geoclue2.enable = true;

  # Enable dbus
  services.dbus.enable = true;

  # Enable udisks2 for automounting
  services.udisks2.enable = true;

  # Enable GVfs for trash and other file operations
  services.gvfs.enable = true;

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Enable thermald for thermal management (Intel)
  services.thermald.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans  # renamed from noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    jetbrains-mono
    # Nerd Fonts - individual packages under nerd-fonts namespace
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
    font-awesome
  ];

  # Enable graphics (replaces deprecated hardware.opengl)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimize store
  nix.settings.auto-optimise-store = true;
}
