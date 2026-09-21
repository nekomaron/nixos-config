{ pkgs, username, ... }:

# TODO: 未整理。Kitty/Firefoxはカテゴリが定まるまで一旦ここに置く。
# 将来的にterminal/, browsers/等への切り出しを検討する。

{
  imports = [
    ./desktop
    ./dev
    ./shell
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.kitty
    pkgs.firefox
  ];
}
