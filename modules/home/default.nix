{ username, ... }:
{
  imports = [
    ./desktop
    ./dev
    ./shell
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";
}
