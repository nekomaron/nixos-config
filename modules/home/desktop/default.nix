{ pkgs, ... }:

{
  home.packages = [
    pkgs.kitty
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
      ];
    };
  };
}
