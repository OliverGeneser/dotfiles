{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.roles.common;
in {
  options.roles.common = {
    enable = lib.mkEnableOption "Enable common configuration";
  };

  config = lib.mkIf cfg.enable {
    system = {
      nix.enable = true;
    };

    cli = {
      terminals.wezterm.enable = true;
      terminals.foot.enable = true;
      shells.fish.enable = true;
      editors = {
        nvim = {
          enable = true;
        };
      };
      programs = {
        git.enable = true;
        htop.enable = true;
      };
    };

    programs = {
      guis.enable = true;
      tuis.enable = true;
    };

    security = {
      sops.enable = true;
    };

    styles.stylix.enable = true;

    # TODO: move this to a separate module
    home.packages = with pkgs; [
      powertop

      src-cli
      #optinix

      (hiPrio parallel)
      moreutils
      nvtopPackages.amd
      unzip
      zip
      gnupg
      e2fsprogs
      wget
      openssl

      showmethekey
    ];
  };
}
