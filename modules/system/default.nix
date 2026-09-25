{ ... }:
{
  imports = [
    ./boot
    ./hardware
    ./display
    ./networking
    ./services
    
    ./locale.nix
    ./fonts.nix
    ./bluetooth.nix
    ./shell.nix
    ./filemanager.nix
    ./ime.nix
    ./steam.nix
  ];
}
