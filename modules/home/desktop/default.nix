{ pkgs, quickshell,config, ... }:

let
  quickshellSrc = ../../../modules/home/desktop/quickshell;
in
{
  home.packages = [
    quickshell.packages.${pkgs.system}.default
    pkgs.playerctl
    pkgs.swww
    pkgs.libnotify
    (pkgs.python3.withPackages (ps: [ ps.dbus-python ps.pygobject3 ]))
  ];

  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink quickshellSrc;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
      ];
      exec-once = [
        "sh -c 'QML2_IMPORT_PATH=${pkgs.kdePackages.qt5compat}/lib/qt-6/qml:$QML2_IMPORT_PATH qs'"
      ];
    };
  };
}
