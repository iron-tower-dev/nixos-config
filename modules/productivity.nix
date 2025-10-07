{ config, pkgs, ... }:

{
  # Productivity applications module
  
  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "derrick" ];
  };
  
  # Email - Thunderbird (installed via packages below)
  # Thunderbird profiles should be configured in Home Manager if needed
  
  # Install productivity packages
  environment.systemPackages = with pkgs; [
    # Password management
    _1password
    _1password-gui
    
    # Email
    protonmail-bridge  # Proton Mail Bridge for Thunderbird (Thunderbird managed by Home Manager)
    
    # Calendar integration
    gnome.gnome-calendar
    
    # Additional productivity tools
    obsidian           # Note taking
    libreoffice-fresh  # Office suite
    
    # PDF and documents
    evince             # PDF viewer
    pdfarranger        # PDF manipulation
  ];
  
  # Enable gnome-keyring for password storage
  services.gnome.gnome-keyring.enable = true;
  
  # PolicyKit for 1Password
  security.polkit.enable = true;
}
