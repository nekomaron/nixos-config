{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alh";
      gs = "git status";
      gc = "git commit";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      inline_height = 5;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "\${custom.ssh}"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      palette = "tokyo_night";

      palettes.tokyo_night = {
        bg1     = "#1a1b26";
        bg2     = "#24283b";
        purple  = "#3b2c58";
        lavender= "#c0caf5";
        blue    = "#7aa2f7";
        magenta = "#bb9af7";
        red     = "#f7768e";
        orange  = "#ff9e64";
        yellow  = "#e0af68";
        green   = "#9ece6a";
        teal    = "#1abc9c";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };

      directory = {
        style = "bg:blue fg:bg1 bold";
        format = "[](fg:blue)[  $path ]($style)[](fg:blue bg:purple)";
        truncation_symbol = "…/";
        truncation_length = 3;
        truncate_to_repo = false;
        home_symbol = "~";
      };

      git_branch = {
        style = "bg:purple fg:lavender bold";
        format = "[  $branch ]($style)[](fg:purple bg:bg1)";
      };

      git_status = {
        style = "bg:bg2 fg:lavender bold";
        format = "[$all_status$ahead_behind ]($style)[](fg:bg2 bg:bg1)";
        conflicted = "[   $count](fg:red bg:bg2) ";
        ahead = "[  $count](fg:green bg:bg2) ";
        behind = "[  $count](fg:red bg:bg2) ";
        diverged = "[  $ahead_count $behind_count](fg:yellow bg:bg2) ";
        untracked = "[  $count](fg:teal bg:bg2) ";
        stashed = "[ 󱝍 $count](fg:magenta bg:bg2) ";
        modified = "[ 󰏫 $count](fg:orange bg:bg2) ";
        staged = "[  $count](fg:green bg:bg2) ";
        renamed = "[ 󰑕 $count](fg:teal bg:bg2) ";
        deleted = "[  $count](fg:red bg:bg2) ";
      };

      custom.ssh = {
        command = "echo ''";
        when = ''test -n "$SSH_CONNECTION" || test -n "$SSH_TTY"'';
        symbol = " 󰣀 ";
        style = "bg:orange fg:bg1 bold";
        format = "[  $symbol ]($style)[](fg:orange bg:teal)";
      };

      nix_shell = {
        style = "bg:teal fg:bg1 bold";
        format = "[ 󱄅 $state ]($style)[](fg:teal bg:yellow)";
        heuristic = true;
      };

      cmd_duration = {
        style = "bg:yellow fg:bg1 bold";
        format = "[ 󱑆 $duration ]($style)";
        min_time = 500;
      };
    };
  };
}
