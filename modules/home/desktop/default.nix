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
    pkgs.cliphist
    pkgs.wl-clipboard
  ];

  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink quickshellSrc;
  };

  home.file."Pictures/system/wallpaper/.keep".text = "";

  home.file."Pictures/system/greetd-assets".source =
    config.lib.file.mkOutOfStoreSymlink ../../../modules/system/display/assets;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"

        # Screenshot
        ", Print, exec, ~/.local/bin/screenshot.sh region"
        "$mod SHIFT, 3, exec, ~/.local/bin/screenshot.sh full"
        "$mod SHIFT, 4, exec, ~/.local/bin/screenshot.sh region"
      ];

      env = [
        "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/ssh-agent"
      ];

      exec-once = [
        "sh -c 'QML2_IMPORT_PATH=${pkgs.kdePackages.qt5compat}/lib/qt-6/qml:$QML2_IMPORT_PATH qs'"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };
}
