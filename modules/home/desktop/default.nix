{ pkgs, quickshell,config, ... }:

let
  quickshellSrc = ../../../modules/home/desktop/quickshell;
in
{
  home.packages = [
    quickshell.packages.${pkgs.system}.default
    pkgs.playerctl
    pkgs.awww
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
    configType = "hyprlang";
    settings = {
      "$mod" = "SUPER";
        bind = [
      "$mod, Return, exec, qs ipc call launcher toggle"
      "$mod, S, exec, kitty"
      "$mod, Q, killactive"
      "$mod, V, exec, thunar"
      "$mod, B, exec, firefox"
      "$mod, F, fullscreen"
      "$mod, T, togglefloating"

      # フォーカス移動 (Vimスタイル: h=左, j=下, k=上, l=右)
      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      # ウィンドウ自体の移動 (Vimスタイル)
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, J, movewindow, d"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, L, movewindow, r"

      # ワークスペース切り替え(数字)
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"

      # ワークスペース切り替え(前後、Vimライクにブラケットキー)
      "$mod, bracketleft, workspace, e-1"
      "$mod, bracketright, workspace, e+1"

      # ウィンドウをワークスペースへ移動
      "$mod CTRL, 1, movetoworkspace, 1"
      "$mod CTRL, 2, movetoworkspace, 2"
      "$mod CTRL, 3, movetoworkspace, 3"
      "$mod CTRL, 4, movetoworkspace, 4"
      "$mod CTRL, 5, movetoworkspace, 5"

      # Screenshot
      ", Print, exec, ~/.local/bin/screenshot.sh region"
      "$mod SHIFT, 3, exec, ~/.local/bin/screenshot.sh full"
      "$mod SHIFT, 4, exec, ~/.local/bin/screenshot.sh region"
   ];

      env = [
        "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/ssh-agent"
        "GTK_IM_MODULE,fcitx"
        "QT_IM_MODULE,fcitx"
        "XMODIFIERS,@im=fcitx"
        "SDL_IM_MODULE,fcitx"
      ];

      exec-once = [
        "fcitx5 -d"
        "sh -c 'QML2_IMPORT_PATH=${pkgs.kdePackages.qt5compat}/lib/qt-6/qml:$QML2_IMPORT_PATH qs'"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      windowrule = [
        "match:class steam, float on"
        "match:class gamescope, fullscreen on"
      ];    
    };
  };
}
