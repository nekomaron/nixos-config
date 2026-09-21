{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/regreet 0755 greeter greeter -"
  ];
}
