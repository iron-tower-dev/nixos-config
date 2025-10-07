{ config, pkgs, ... }:

{
  # Audio configuration - PipeWire with full compatibility
  
  # Disable PulseAudio (conflicts with PipeWire)
  services.pulseaudio.enable = false;  # Renamed from hardware.pulseaudio
  
  # Enable real-time permissions for audio
  security.rtkit.enable = true;
  
  # PipeWire - Modern audio server
  services.pipewire = {
    enable = true;
    
    # ALSA support
    alsa = {
      enable = true;
      support32Bit = true;
    };
    
    # PulseAudio compatibility
    pulse.enable = true;
    
    # JACK compatibility
    jack.enable = true;
    
    # WirePlumber session manager (default, but explicit)
    wireplumber.enable = true;
  };
  
  # Audio-related packages
  environment.systemPackages = with pkgs; [
    # GUI audio controls
    pavucontrol        # PulseAudio/PipeWire volume control
    pwvucontrol        # Native PipeWire volume control
    
    # CLI audio tools
    playerctl          # Media player control
    pulsemixer         # Terminal mixer
    alsa-utils         # ALSA utilities
    
    # PipeWire compatibility provided by services.pipewire configuration
    # (alsa, pulse, jack support enabled above)
  ];
  
  # Bluetooth audio support (blueman enabled in system.nix)
  
  # Additional audio tweaks
  environment.variables = {
    # Ensure PipeWire is the default audio server
    PULSE_RUNTIME_PATH = "/run/user/1000/pulse";
  };
}