{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "PlemolJP Console NF";
      size = 14.0;
    };
    settings = {
      bold_font = "PlemolJP Console NF Bold";
      italic_font = "PlemolJP Console NF Italic";
      bold_italic_font = "PlemolJP Console NF Bold Italic";

      # Tokyo Night カラースキーム
      background = "#1a1b26";
      foreground = "#c0caf5";
      selection_background = "#364a82";
      selection_foreground = "#c0caf5";
      url_color = "#73daca";

      cursor = "#c0caf5";
      cursor_text_color = "#1a1b26";

      active_border_color = "#7aa2f7";
      inactive_border_color = "#292e42";
      bell_border_color = "#e0af68";

      active_tab_background = "#7aa2f7";
      active_tab_foreground = "#1a1b26";
      inactive_tab_background = "#292e42";
      inactive_tab_foreground = "#545c7e";
      tab_bar_background = "#16161e";

      color0 = "#15161e";
      color1 = "#f7768e";
      color2 = "#9ece6a";
      color3 = "#e0af68";
      color4 = "#7aa2f7";
      color5 = "#bb9af7";
      color6 = "#7dcfff";
      color7 = "#a9b1d6";

      color8 = "#414868";
      color9 = "#f7768e";
      color10 = "#9ece6a";
      color11 = "#e0af68";
      color12 = "#7aa2f7";
      color13 = "#bb9af7";
      color14 = "#7dcfff";
      color15 = "#c0caf5";

      mark1_foreground = "#1a1b26";
      mark1_background = "#7aa2f7";
      mark2_foreground = "#1a1b26";
      mark2_background = "#bb9af7";
      mark3_foreground = "#1a1b26";
      mark3_background = "#9ece6a";

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_edge = "bottom";
      tab_bar_align = "left";

      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
    };
  };
}
