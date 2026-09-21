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
}
