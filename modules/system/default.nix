{ ... }:
{
  imports = [
    ./boot
    ./hardware
    ./display
    ./networking
    ./services
    
    ./fonts.nix
    ./bluetooth.nix
  ];
}
