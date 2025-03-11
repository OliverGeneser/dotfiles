{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib;
with lib.custom;
with inputs; let
  cfg = config.cli.editors.nvim;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
in {
  options.cli.editors.nvim = with types; {
    enable = mkBoolOpt false "enable neovim editor";
  };

  config =
    mkIf
    cfg.enable
    {
      home.packages = with pkgs; [
        ripgrep
        fd
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

      xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "/home/${config.custom.user.name}/dotfiles/modules/home/cli/editors/nvim/lua";
    };
}
