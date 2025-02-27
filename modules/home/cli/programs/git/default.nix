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
          branch = {
            sort = "-committerdate";
          };

          commit = {
            verbose = true;
          };

          color = {
            ui = true;
          };

          column = {
            ui = "auto";
          };

          core = {
            editor = "nvim";
            pager = "delta";
          };

          delta = {
            enable = true;
            light = false;
            navigate = true;
            options.syntax-theme = "catppuccin";
            side-by-side = false;
          };

          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
          };

          fetch = {
            all = true;
            prune = true;
            pruneTags = true;
          };

          gpg = {
            format = "ssh";
          };

          help = {
            autocorrect = "prompt";
          };

          init = {
            defaultBranch = "main";
          };

          interactive = {
            diffFilter = "delta --color-only";
          };

          merge = {
            conflictstyle = "zdiff3";
          };

          pull = {
            rebase = true;
          };

          push = {
            autoSetupRemote = true;
            default = "simple";
            followTags = true;
          };

          rebase = {
            autoSquash = true;
            autoStash = true;
            updateRefs = true;
          };

          rerere = {
            autoupdate = true;
            enabled = true;
          };

          tag = {
            sort = "version:refname";
          };
        }
        // rewriteURL;
    };
  };
}
