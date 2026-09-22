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
  ];
}
