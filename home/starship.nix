{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };
      
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        conflicted = "🏳";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++\($count)](green)";
        renamed = "👅";
        deleted = "🗑";
      };
      
      nix_shell = {
        symbol = " ";
        format = "via [\$symbol\$state](\$style) ";
        style = "bold blue";
      };
      
      nodejs = {
        symbol = " ";
        format = "via [\$symbol\$version](\$style) ";
      };
      
      rust = {
        symbol = " ";
        format = "via [\$symbol\$version](\$style) ";
      };
      
      golang = {
        symbol = " ";
        format = "via [\$symbol\$version](\$style) ";
      };
      
      python = {
        symbol = " ";
        format = "via [\$symbol\$version](\$style) ";
      };
      
      kotlin = {
        symbol = "🅺 ";
        format = "via [\$symbol\$version](\$style) ";
      };
      
      elixir = {
        symbol = " ";
        format = "via [\$symbol\$version](\$style) ";
      };
      
      dotnet = {
        symbol = " ";
        format = "via [\$symbol\$version](\$style) ";
      };
    };
  };
}
