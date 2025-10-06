{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "Nord";
      };
    };
    
    extraConfig = {
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };
  
  programs.lazygit = {
    enable = true;
  };
}
