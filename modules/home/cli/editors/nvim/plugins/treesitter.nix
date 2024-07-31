{config, ...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings = {
          indent = {
            enable = true;
          };

          incremental_selection = {
            enable = true;
            keymaps = {
              initSelection = "<C-space>";
              nodeIncremental = "<C-space>";
              nodeDecremental = "<bs>";
            };
          };
        };
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          c
          css
          bash
          fish

          vim
          vimdoc
          vhs

          json
          toml
        ];
      };
      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ai" = "@conditional.outer";
            "ii" = "@conditional.inner";
            "al" = "@loop.outer";
            "il" = "@loop.inner";
            "ak" = "@block.outer";
            "ik" = "@block.inner";
            "is" = "@statement.inner";
            "as" = "@statement.outer";
            "ad" = "@comment.outer";
            "am" = "@call.outer";
            "im" = "@call.inner";
          };
        };
        move = {
          enable = true;
          setJumps = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };

        swap = {
          enable = true;
          swapNext = {
            ")a" = "@parameter.inner";
          };
          swapPrevious = {
            ")A" = "@parameter.inner";
          };
        };
      };
    };
  };
}
