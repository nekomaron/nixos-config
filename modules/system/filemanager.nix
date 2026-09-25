{ pkgs, ... }:

let
  mkJaWrapped = import ../lib/ja-wrap.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    (mkJaWrapped pkgs.thunar [ "Thunar" "thunar" ])
    pkgs.thunar-volman
    pkgs.thunar-archive-plugin
    pkgs.tumbler
    pkgs.gvfs
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
}
