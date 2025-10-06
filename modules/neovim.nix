{ config, pkgs, inputs, ... }:

{
  # Neovim as the primary editor with comprehensive language support
  # This provides a basic system-level Neovim installation
  # Users should configure Neovim further in home-manager or with a Neovim distribution
  
  environment.systemPackages = with pkgs; [
    # Neovim
    neovim
    
    # Language servers for all development languages
    # .NET
    omnisharp-roslyn
    netcoredbg
    
    # Elixir
    elixir-ls
    
    # Web/JavaScript/TypeScript/Angular
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
    nodePackages."@angular/language-server"
    nodePackages.prettier
    
    # Kotlin
    kotlin-language-server
    
    # Go
    gopls
    gotools
    golangci-lint
    delve
    
    # Rust
    rust-analyzer
    rustfmt
    clippy
    
    # Additional LSPs and tools
    lua-language-server
    nil  # Nix LSP
    nixpkgs-fmt
    alejandra  # Better Nix formatter
    
    # YAML, TOML, etc.
    nodePackages.yaml-language-server
    taplo  # TOML LSP
    
    # Markdown
    marksman
    
    # Bash
    nodePackages.bash-language-server
    shellcheck
    shfmt
    
    # Python (useful for Neovim plugins and scripting)
    python311
    python311Packages.pynvim
    
    # Tree-sitter CLI
    tree-sitter
    
    # Debugging adapters
    vscode-extensions.vadimcn.vscode-lldb
    
    # Clipboard support
    wl-clipboard
    xclip
    
    # Fuzzy finders and searchers
    ripgrep
    fd
    fzf
    
    # Git integration
    lazygit
    delta  # Better git diff
  ];

  # Set Neovim as default editor
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Additional Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    configure = {
      customRC = ''
        " Basic settings
        set number
        set relativenumber
        set mouse=a
        set clipboard=unnamedplus
        set expandtab
        set tabstop=2
        set shiftwidth=2
        set smartindent
        set ignorecase
        set smartcase
        set termguicolors
        
        " Leader key
        let mapleader = " "
        
        " Quick save
        nnoremap <leader>w :w<CR>
        
        " This is a minimal config - users should set up their full config
        " in home-manager or use a Neovim distribution like LazyVim, NvChad, etc.
      '';
    };
  };
}
