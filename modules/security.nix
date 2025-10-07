{ config, pkgs, lib, ... }:

{
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = false;
    logReversePathDrops = true;
    
    # Allow specific ports (adjust as needed)
    allowedTCPPorts = [
      # Add ports as needed
    ];
    allowedUDPPorts = [
      # Add ports as needed
    ];
  };

  # Fail2ban for intrusion prevention
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.1/8"
      "::1"
    ];
  };

  # AppArmor for mandatory access control
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  # Enable secure boot preparation (requires manual setup)
  # boot.loader.systemd-boot.enable = true;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };

  # Kernel hardening
  boot.kernelParams = [
    # Disable kernel info leaks
    "kernel.kptr_restrict=2"
    
    # Disable kernel module loading after boot (uncomment if desired)
    # "kernel.modules_disabled=1"
  ];

  # Additional kernel hardening via sysctl
  boot.kernel.sysctl = {
    # Network hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_all" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    
    # Kernel hardening
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.unprivileged_userns_clone" = 0;
    "kernel.yama.ptrace_scope" = 2;
    
    # File system hardening
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
  };

  # Security packages
  environment.systemPackages = with pkgs; [
    # Encryption tools
    cryptsetup
    
    # Security auditing
    lynis
    rkhunter  # chkrootkit removed (unmaintained upstream)
    
    # Password management
    keepassxc
    
    # Network security
    nmap
    wireshark
    tcpdump
    
    # Firewall management
    ufw
    
    # SELinux tools (if using SELinux instead of AppArmor)
    # policycoreutils
    
    # USB security
    usbguard
    
    # Audit framework
    audit
    
    # OpenSSH with hardening
    openssh
  ];

  # SSH hardening is configured per-host in hosts/*/configuration.nix
  # This avoids conflicts and allows each host to have appropriate SSH settings
  # Recommended secure SSH settings:
  #   PasswordAuthentication = false;
  #   PermitRootLogin = "no";
  #   X11Forwarding = false;
  #   KbdInteractiveAuthentication = false;
  #   Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
  #   MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
  #   KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org

  # USB Guard for USB device authorization
  services.usbguard = {
    enable = false;  # Enable if needed, requires configuration
    # dbus.enable = true;
    # rules = ''
    #   # Allow all devices by default (adjust as needed)
    #   allow id 0000:0000
    # '';
  };

  # Audit framework
  security.audit = {
    enable = false;  # Enable if needed
    rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];
  };

  # PAM configuration for security
  security.pam = {
    services = {
      login.enableGnomeKeyring = true;
      # Increase password requirements
      # passwd.text = lib.mkDefault ''
      #   password requisite pam_pwquality.so minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1
      # '';
    };
    
    # Fail delay
    loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "8192";
      }
    ];
  };

  # Enable systemd hardening features
  systemd.coredump.enable = false;

  # Restrict su to wheel group
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    execWheelOnly = true;
  };

  # Additional security settings
  security = {
    # Protect kernel logs
    protectKernelImage = true;
    
    # Disable user namespaces
    # allowUserNamespaces = false;  # May break some containers
    
    # Polkit for privilege escalation
    polkit.enable = true;
    
    # rtkit for realtime permissions
    rtkit.enable = true;
  };
}
