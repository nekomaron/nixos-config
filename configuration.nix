{ pkgs, username, ... }:

{
  imports = [
    ./modules/system
  ];

  system.stateVersion = "25.11";

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "test";
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;   # MB単位、4GB
      cores = 4;
      diskSize = 20480;    # MB単位、20GB
    };
  };

}
