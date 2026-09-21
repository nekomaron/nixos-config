{ pkgs, ... }:

{
  system.stateVersion = "25.11";

  # VM検証用の最低限
  users.users.testuser = {
    isNormalUser = true;
    password = "test";
  };
}
