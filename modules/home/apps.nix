{ pkgs, ... }:

let
  mkJaWrapped = import ../lib/ja-wrap.nix { inherit pkgs; };
in
{
  home.packages = [
    (mkJaWrapped pkgs.keepassxc [ "keepassxc" ])
  ];
}
