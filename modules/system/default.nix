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
    ./shell.nix
    ./filemanager.nix
    ./ime.nix
    ./steam.nix
  ];
}
