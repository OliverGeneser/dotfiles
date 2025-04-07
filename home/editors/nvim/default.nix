{
  pkgs,
  config,
  ...
}: let
  cfg = config.editors.nvim;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  home.packages = with pkgs; [
    ripgrep
    fd
    gnumake
    alejandra
    prettierd
    eslint_d
    # black
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraLuaConfig = ''
      require("geneser")
    '';
  };

  xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "/home/${config.home.username}/dotfiles/home/editors/nvim/lua";
}
