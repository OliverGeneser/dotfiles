{
  self,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.git;
in {
  home.packages = [
    pkgs.delta
    self.packages.${pkgs.system}.gca
  ];

  # enable scrolling in git diff
  home.sessionVariables.DELTA_PAGER = "less -R";

  programs.git = {
    enable = true;

    extraConfig = {
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
    };

    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ecdsa_sk.pub";
      signByDefault = true;
      format = "ssh";
    };

    userEmail = "hello@geneser.xyz";
    userName = "Oliver Geneser";
  };
}
