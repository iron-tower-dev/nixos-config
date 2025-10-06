{ config, pkgs, ... }:

{
  # Development packages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    git-lfs
    gh  # GitHub CLI
    lazygit
    
    # .NET Development
    dotnet-sdk_8
    dotnet-runtime_8
    omnisharp-roslyn
    
    # Elixir/Erlang Development
    elixir
    erlang
    elixir-ls
    rebar3
    
    # Web Development (Node.js/Angular)
    nodejs_22
    nodePackages.npm
    nodePackages.pnpm
    nodePackages.yarn
    nodePackages."@angular/cli"
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    nodePackages.eslint
    
    # Kotlin Development
    kotlin
    kotlin-language-server
    gradle
    jdk21
    jdk17
    jdk11
    maven
    
    # Go Development
    go
    gopls
    gotools
    go-tools
    golangci-lint
    delve  # Go debugger
    
    # Rust Development
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
    
    # Build tools
    gnumake
    cmake
    ninja
    meson
    pkg-config
    
    # Containerization and virtualization
    docker
    docker-compose
    podman
    distrobox
    
    # Database clients
    postgresql
    mysql80
    sqlite
    redis
    
    # API testing
    postman
    insomnia
    
    # Direnv for per-directory environments
    direnv
    
    # Protobuf
    protobuf
    grpc
    grpcurl
  ];

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enable libvirt for virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  # Enable direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # Environment variables for development
  environment.variables = {
    # Increase Node.js memory limit
    NODE_OPTIONS = "--max-old-space-size=4096";
    
    # Go environment
    GOPATH = "$HOME/go";
    
    # Rust environment
    CARGO_HOME = "$HOME/.cargo";
  };
}
