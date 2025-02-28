{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.roles.server;
in {
  options.roles.server = {
    enable = lib.mkEnableOption "Enable server configuration";
  };

  config = lib.mkIf cfg.enable {
    system = {
      nix.enable = true;
    };

    cli = {
      terminals.wezterm.enable = true;
      shells.fish.enable = true;

      editors = {
        nvim.enable = true;
      };
      programs = {
        git.enable = true;
        ssh.enable = true;
        htop.enable = true;
        eza.enable = true;
        fzf.enable = true;
        modern-unix.enable = true;
        nix-index.enable = true;
        direnv.enable = true;
      };
    };

    security = {
      sops.enable = true;
    };

    styles.stylix.enable = true;

    # TODO: move this to a separate module
    home.packages = with pkgs; [
      powertop

      src-cli

      (hiPrio parallel)
      moreutils
      unzip
      zip
      gnupg
      e2fsprogs
      wget
      openssl
    ];
  };
}
