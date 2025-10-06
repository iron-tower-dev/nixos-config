# Development Shells

This directory contains information about using development shells (devshells) with your NixOS configuration.

## What are Development Shells?

Development shells are isolated environments that provide all the tools and dependencies needed for a specific project or language. They're similar to virtual environments in Python or containers in Docker, but lighter weight and declarative.

## Using Devshells from the Flake

Your main `flake.nix` already defines several development shells. You can enter them using:

```bash
# Enter a specific devshell
nix develop .#dotnet      # .NET development
nix develop .#elixir      # Elixir development
nix develop .#angular     # Angular/Web development
nix develop .#kotlin      # Kotlin development
nix develop .#go          # Go development
nix develop .#rust        # Rust development
nix develop .#full        # Full-stack (all languages)
```

## Project-Specific Devshells

For individual projects, create a `flake.nix` in your project directory:

### Example: .NET Project

```nix
{
  description = "My .NET Project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          dotnet-sdk_8
          omnisharp-roslyn
        ];
        
        shellHook = ''
          echo "🔷 .NET Development Environment"
          echo "SDK: $(dotnet --version)"
          export DOTNET_CLI_TELEMETRY_OPTOUT=1
        '';
      };
    };
}
```

Then enter the devshell with:
```bash
nix develop
```

### Example: Angular Project

```nix
{
  description = "My Angular Project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_22
          nodePackages.npm
          nodePackages."@angular/cli"
          nodePackages.typescript
        ];
        
        shellHook = ''
          echo "🅰️  Angular Development Environment"
          echo "Node: $(node --version)"
          echo "Angular CLI: $(ng version --minimal)"
          export NODE_OPTIONS="--max-old-space-size=4096"
        '';
      };
    };
}
```

## Using direnv for Automatic Shell Activation

Instead of manually running `nix develop`, you can use direnv to automatically enter the devshell when you `cd` into a project directory.

1. Create a `.envrc` file in your project root:
   ```bash
   use flake
   ```

2. Allow direnv to load it:
   ```bash
   direnv allow
   ```

Now, whenever you enter the directory, the devshell will activate automatically!

## Legacy shell.nix Support

If you prefer the older `shell.nix` format (non-flake), you can create one:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Your dependencies here
    go
    gopls
  ];
  
  shellHook = ''
    echo "Development environment loaded"
  '';
}
```

Enter with:
```bash
nix-shell
```

## Best Practices

1. **Keep devshells minimal**: Only include what you need for development
2. **Use shellHook for setup**: Initialize environment variables, print info, etc.
3. **Version pin when needed**: For production, pin nixpkgs to a specific commit
4. **Combine with direnv**: Automate environment activation
5. **Document dependencies**: Explain why each package is needed

## Common Patterns

### Multi-language Project

```nix
devShells.${system}.default = pkgs.mkShell {
  buildInputs = with pkgs; [
    # Backend
    go
    gopls
    
    # Frontend
    nodejs_22
    nodePackages.typescript
    
    # Database
    postgresql
    
    # Tools
    docker-compose
  ];
};
```

### With Environment Variables

```nix
shellHook = ''
  export DATABASE_URL="postgresql://localhost:5432/mydb"
  export API_KEY="dev-key-123"
  export DEBUG=true
'';
```

### With Pre-commit Hooks

```nix
buildInputs = with pkgs; [
  pre-commit
  # ... other tools
];

shellHook = ''
  pre-commit install
'';
```

## Troubleshooting

### "Package not found"
Make sure you're using the correct package name from nixpkgs. Search at https://search.nixos.org/packages

### "Conflict with system packages"
Devshells should isolate you from system packages, but if you need to access them, use `NIX_PATH`:
```bash
nix develop --extra-experimental-features "nix-command flakes"
```

### "Slow to enter"
First entry builds/downloads packages. Subsequent entries are fast. Use a binary cache to speed up initial setup.

## Resources

- [NixOS Wiki: Development Environments](https://nixos.wiki/wiki/Development_environment_with_nix-shell)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [direnv documentation](https://direnv.net/)
