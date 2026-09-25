{ pkgs, ... }:

{
  home.packages = [
    pkgs.grim
    pkgs.slurp
  ];

  home.file."Pictures/Screenshots/.keep".text = "";

  home.file.".local/bin/screenshot.sh" = {
    source = ../scripts/screenshot.sh;
    executable = true;
  };
}
