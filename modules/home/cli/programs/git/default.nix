{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.git;

  rewriteURL =
    lib.mapAttrs' (key: value: {
      name = "url.${key}";
      value = {insteadOf = value;};
    })
    cfg.urlRewrites;
in {
  options.cli.programs.git = with types; {
    enable = mkBoolOpt false "Whether or not to enable git.";
    email = mkOpt (nullOr str) "hello@geneser.xyz" "The email to use with git.";
    urlRewrites = mkOpt (attrsOf str) {} "url we need to rewrite i.e. ssh to http";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Oliver Geneser";
      userEmail = cfg.email;

      signing = {
        signByDefault = true;
        key = "~/.ssh/id_ecdsa_sk.pub";
      };

      extraConfig =
        {
          core = {
            editor = "nvim";
            pager = "delta";
          };

          color = {
            ui = true;
          };

          interactive = {
            diffFitler = "delta --color-only";
          };

          delta = {
            enable = true;
            navigate = true;
            light = false;
            side-by-side = false;
            options.syntax-theme = "catppuccin";
          };

          gpg = {
            format="ssh";
          };          
          
          pull = {
            ff = "only";
          };

          push = {
            default = "current";
            autoSetupRemote = true;
          };

          init = {
            defaultBranch = "init";
          };
        }
        // rewriteURL;
    };

    programs.lazygit = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --color-only --dark --paging=never";
            useConfig = false;
          };
        };
        customCommands = [
          {
            key = "W";
            command = "git commit -m '{{index .PromptResponses 0}}' --no-verify";
            description = "commit without verification";
            context = "global";
            subprocess = true;
          }
          {
            key = "S";
            command = "git commit -m '{{index .PromptResponses 0}}' --no-gpg-sign";
            description = "commit without gpg signing";
            context = "global";
            subprocess = true;
          }
        ];
      };
    };
  };
}
