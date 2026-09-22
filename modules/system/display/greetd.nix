{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = [
    pkgs.adwaita-icon-theme
    pkgs.gtk3
  ];

  environment.etc."greetd/regreet.toml".text = ''
    skip_selection = true

    [GTK]
    icon_theme_name = "Adwaita"

    [widget.clock]
    format = "%Y-%m-%d %H:%M (%a)"
    resolution = "1000ms"
    locale = "en_US"
  '';

  systemd.tmpfiles.rules = [
    "d /var/log/regreet 0755 greeter greeter -"
    "d /var/lib/regreet 0755 greeter greeter -"
  ];
}
