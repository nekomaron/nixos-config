{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    nixd
    marksman
    yaml-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-treesitter.withAllGrammars
      telescope-nvim
      plenary-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      markview-nvim
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
    ];

    initLua = ''
      ${builtins.readFile ./lua/options.lua}
      ${builtins.readFile ./lua/keymaps.lua}
      ${builtins.readFile ./lua/telescope.lua}
      ${builtins.readFile ./lua/cmp.lua}
      ${builtins.readFile ./lua/markview.lua}
      ${builtins.readFile ./lua/lsp.lua}
    '';
  };
}
