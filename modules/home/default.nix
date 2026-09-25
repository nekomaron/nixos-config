{ pkgs, username, ... }:


{
  imports = [
    ./desktop
    ./dev
    ./shell
    ./terminal
    ./editor
    ./browser
    ./cli-tools
    ./theming
    ./screenshot
  ];


  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keepassxc-ssh-agent.socket";
  };

  home.packages = [
    pkgs.keepassxc
  ];

  services.ssh-agent.enable = true;
}
