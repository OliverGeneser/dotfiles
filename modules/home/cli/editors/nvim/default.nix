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
    additionalLanguages = mkBoolOpt false "enable additional languages";
  };

  config =
    mkIf
    cfg.enable
    {
      home.packages = with pkgs;
        [
          ripgrep
          fd
          lua-language-server
          alejandra
          stylua
          prettierd
        ]
        ++ lib.optionals (cfg.additionalLanguages) [
          # black
          tailwindcss-language-server
          eslint_d
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
