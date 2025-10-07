{
  description = "Modular NixOS configuration with Flakes and Home Manager";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Stylix - System-wide theming
    stylix.url = "github:danth/stylix";

    # Nix-Gaming for gaming optimizations
    nix-gaming.url = "github:fufexan/nix-gaming";

    # NixVim for Neovim configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, stylix, nix-gaming, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # NixOS configuration
      nixosConfigurations = {
        # Desktop configuration
        iron-tower = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Core system configuration
            ./configuration.nix
            
            # Host-specific configuration
            ./hosts/iron-tower/configuration.nix
            ./hosts/iron-tower/hardware-configuration.nix
            
            # Stylix for system-wide theming
            stylix.nixosModules.stylix
            
            # System modules
            ./modules/bootloader.nix
            ./modules/users.nix
            ./modules/system.nix
            
            # Feature modules
            ./modules/gaming.nix
            ./modules/development.nix
            ./modules/productivity.nix
            ./modules/hyprland.nix
            ./modules/security.nix
            ./modules/performance.nix
            ./modules/stylix.nix
            ./modules/shells.nix
            ./modules/neovim.nix
            
            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.derrick = import ./home/home.nix;
            }
          ];
        };
        
        # Laptop configuration
        iron-zephyrus = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Core system configuration
            ./configuration.nix
            
            # Host-specific configuration
            ./hosts/iron-zephyrus/configuration.nix
            ./hosts/iron-zephyrus/hardware-configuration.nix
            
            # Stylix for system-wide theming
            stylix.nixosModules.stylix
            
            # System modules
            ./modules/bootloader.nix
            ./modules/users.nix
            ./modules/system.nix
            
            # Feature modules
            ./modules/gaming.nix
            ./modules/development.nix
            ./modules/productivity.nix
            ./modules/hyprland.nix
            ./modules/security.nix
            ./modules/performance.nix
            ./modules/stylix.nix
            ./modules/shells.nix
            ./modules/neovim.nix
            
            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.derrick = import ./home/home.nix;
            }
          ];
        };
        
        # VM configuration for testing
        iron-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Core system configuration
            ./configuration.nix
            
            # Host-specific configuration
            ./hosts/iron-vm/configuration.nix
            ./hosts/iron-vm/hardware-configuration.nix
            
            # Stylix for system-wide theming
            stylix.nixosModules.stylix
            
            # System modules
            ./modules/bootloader.nix
            ./modules/users.nix
            ./modules/system.nix
            
            # Feature modules
            ./modules/gaming.nix
            ./modules/development.nix
            ./modules/productivity.nix
            ./modules/hyprland.nix
            ./modules/security.nix
            ./modules/performance.nix
            ./modules/stylix.nix
            ./modules/shells.nix
            ./modules/neovim.nix
            
            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.derrick = import ./home/home.nix;
            }
          ];
        };
      };

      # Development shells for various languages
      devShells.${system} = {
        # .NET development
        dotnet = pkgs.mkShell {
          buildInputs = with pkgs; [
            dotnet-sdk_8
            omnisharp-roslyn
          ];
          shellHook = ''
            echo "🔷 .NET Development Environment"
            echo "SDK: $(dotnet --version)"
          '';
        };

        # Elixir development
        elixir = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir
            erlang
            elixir-ls
          ];
          shellHook = ''
            echo "💧 Elixir Development Environment"
            echo "Elixir: $(elixir --version | head -n 1)"
          '';
        };

        # Angular/Web development
        angular = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            nodePackages.npm
            nodePackages."@angular/cli"
            nodePackages.typescript
            nodePackages.typescript-language-server
          ];
          shellHook = ''
            echo "🅰️  Angular Development Environment"
            echo "Node: $(node --version)"
            echo "Angular CLI: $(ng version --minimal)"
          '';
        };

        # Kotlin development
        kotlin = pkgs.mkShell {
          buildInputs = with pkgs; [
            kotlin
            kotlin-language-server
            gradle
            jdk21
          ];
          shellHook = ''
            echo "🅺 Kotlin Development Environment"
            echo "Kotlin: $(kotlinc -version)"
          '';
        };

        # Go development
        go = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gopls
            gotools
            go-tools
          ];
          shellHook = ''
            echo "🐹 Go Development Environment"
            echo "Go: $(go version)"
          '';
        };

        # Rust development
        rust = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rustfmt
            rust-analyzer
            clippy
          ];
          shellHook = ''
            echo "🦀 Rust Development Environment"
            echo "Rust: $(rustc --version)"
          '';
        };

        # Full-stack development (all languages)
        full = pkgs.mkShell {
          buildInputs = with pkgs; [
            # .NET
            dotnet-sdk_8
            omnisharp-roslyn
            
            # Elixir
            elixir
            erlang
            elixir-ls
            
            # Web/Angular
            nodejs_22
            nodePackages.npm
            nodePackages."@angular/cli"
            nodePackages.typescript
            nodePackages.typescript-language-server
            
            # Kotlin
            kotlin
            kotlin-language-server
            gradle
            jdk21
            
            # Go
            go
            gopls
            gotools
            
            # Rust
            rustc
            cargo
            rustfmt
            rust-analyzer
            clippy
          ];
          shellHook = ''
            echo "🚀 Full-Stack Development Environment"
            echo "All language toolchains loaded!"
          '';
        };
      };
    };
}
