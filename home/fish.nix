{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting
      
      # Vi key bindings (optional)
      # fish_vi_key_bindings
    '';
    
    shellAliases = {
      # Already defined in system module, but can override here
    };
    
    functions = {
      # Custom fish functions
      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';
    };
    
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
    ];
  };
}
