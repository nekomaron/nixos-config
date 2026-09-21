{ pkgs, ... }:

{
  imports = [
    ./modules/system
  ];

  system.stateVersion = "25.11";

  users.users.testuser = {
    isNormalUser = true;
    password = "test";
  };
}
