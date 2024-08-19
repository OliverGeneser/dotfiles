{ pkgs
, lib
, inputs
, config
, ...
}:
with lib;
with lib.custom;
with inputs; let
  cfg = config.cli.editors.nvim;

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]));

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };

in
{
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
          go
          lua-language-server
          rustup
          black
        ];

        programs.neovim = {
          enable = true;
          #package = pkgs.neovim;
          viAlias = true;
          vimAlias = true;
          defaultEditor = true;
          coc.enable = false;
          withNodeJs = true;

          plugins = [
            treesitterWithGrammars
          ];
        };

        home.file = {
          ".config/nvim" = {
            source = ./nvim;
            recursive = true;
          };
        };

        home.file.".config/nvim/lua/geneser/init.lua".text = ''
          require("geneser.set")
          require("geneser.remap")
          vim.opt.runtimepath:append("${treesitter-parsers}")
        '';

        # Treesitter is configured as a locally developed module in lazy.nvim
        # we hardcode a symlink here so that we can refer to it in our lazy config
        home.file.".local/share/nvim/nix/nvim-treesitter/" = {
          recursive = true;
          source = treesitterWithGrammars;
        };
      };
}
