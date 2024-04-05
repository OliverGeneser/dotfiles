{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.git;

  rewriteURL =
    lib.mapAttrs' (key: value: {
      name = "url.${key}";
      value = {insteadOf = value;};
    })
    cfg.urlRewrites;
in {
  options.apps.tools.git = with types; {
    enable = mkBoolOpt false "Enable or disable git";
    email = mkOpt (nullOr str) "hello@geneser.xyz" "The email to use with git.";
    urlRewrites = mkOpt (attrsOf str) {} "url we need to rewrite i.e. ssh to http";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      git-remote-gcrypt
      commitizen
    ];

    environment.shellAliases = {
      # Git aliases
      ga = "git add .";
      gc = "git commit -m ";
      gp = "git push -u origin";

    };

    home.programs.git = {
      enable = true;
      userName = "Oliver Geneser";
      userEmail = cfg.email;

      # signing = {
      #   signByDefault = true;
      #   key = "xxxx xxxx";
      # };

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

          pull = {
            ff = "only";
          };

          push = {
            default = "current";
            autoSetupRemote = true;
          };

          init = {
            defaultBranch = "main";
          };
        }
        // rewriteURL;
      };

    # home.configFile."git/config".text = import ./config.nix {sshKeyPath = "/home/${config.user.name}/.ssh/key.pub"; name = ""; email = "";};
    home.configFile."lazygit/config.yml".source = ./lazygitConfig.yml;
    
    home.persist.directories = [
      ".config/systemd" # For git maintainance
    ];
  };
}
