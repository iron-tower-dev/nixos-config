{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # User configuration
    userName = "Derrick Southworth";
    userEmail = "derricksouthworth@gmail.com";
    
    # Delta for better diffs
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "Nord";
      };
    };
    
    extraConfig = {
      # Core settings
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = true;
      };
      
      # Merge and diff settings
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      
      # GitHub CLI integration
      credential = {
        helper = "cache --timeout=3600";
      };
    };
    
    # Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };
  
  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
  };
  
  # Lazygit
  programs.lazygit = {
    enable = true;
  };
  
  # SSH configuration for GitHub
  programs.ssh = {
    enable = true;
    
    extraConfig = ''
      # GitHub
      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/github
        AddKeysToAgent yes
    '';
  };
  
  # Ensure SSH directory exists
  home.activation.ensureSshDir = {
    after = [];
    before = [ "checkLinkTargets" ];
    data = ''
      mkdir -p $HOME/.ssh
      chmod 700 $HOME/.ssh
    '';
  };
}
