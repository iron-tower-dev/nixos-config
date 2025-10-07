{ config, pkgs, ... }:

{
  # Enable shells
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;  # Required for user shell

  # Shell-related packages
  environment.systemPackages = with pkgs; [
    # Prompts
    starship
    oh-my-posh
    
    # Modern CLI tools (already in system.nix, but listed for reference)
    eza        # ls replacement
    fd         # find replacement
    ripgrep    # grep replacement
    bat        # cat replacement
    fzf        # fuzzy finder
    zoxide     # cd replacement
    
    # Shell completion helpers
    nix-index
    comma      # Run packages without installing
    
    # Additional shell tools
    tmux
    zellij     # Modern tmux alternative
    atuin      # Shell history sync
    mcfly      # Smart shell history
    
    # Shell enhancements
    direnv
    nix-direnv
    
    # Documentation
    tldr
    tealdeer   # Fast tldr client
  ];

  # Bash configuration
  programs.bash = {
    completion.enable = true;  # Renamed from enableCompletion
    enableLsColors = true;
    
    # Bash-specific aliases will be in home-manager
  };

  # Zsh configuration
  programs.zsh = {
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
    };
  };

  # Fish configuration is handled entirely by home-manager

  # Shell aliases (system-wide)
  environment.shellAliases = {
    # Nix helpers
    nrs = "sudo nixos-rebuild switch --flake .";
    nrb = "sudo nixos-rebuild boot --flake .";
    nrt = "sudo nixos-rebuild test --flake .";
    nfu = "nix flake update";
    nfc = "nix flake check";
    
    # Modern replacements
    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first";
    la = "eza -la --icons --group-directories-first";
    lt = "eza --tree --icons --group-directories-first";
    cat = "bat";
    find = "fd";
    grep = "rg";
    
    # Git shortcuts
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    gco = "git checkout";
    gcb = "git checkout -b";
    
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    
    # System
    update = "sudo nixos-rebuild switch --flake ~/nixos-config";
    cleanup = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
  };
}
