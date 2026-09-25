{ pkgs, ... }:

let
  mkJaWrapped = import ../lib/ja-wrap.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    (mkJaWrapped pkgs.xfce.thunar [ "Thunar" "thunar" ])
    pkgs.xfce.thunar-volman
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.tumbler
    pkgs.gvfs
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
}
