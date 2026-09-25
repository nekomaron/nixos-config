{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.protonup-qt
  ];
}
