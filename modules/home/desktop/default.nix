{ pkgs, quickshell,... }:

{
  home.packages = [
    pkgs.kitty
    quickshell.packages.${pkgs.system}.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
      ];
      exec-once = [
       "qs"
       ];
    };
  };
}
