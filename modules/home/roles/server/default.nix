{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
with inputs; let
  cfg = config.roles.server;
in {
  options.roles.server = {
    enable = mkEnableOption "Enable server configuration";
  };

  config = mkIf cfg.enable {
    system = {
      nix.enable = true;
    };

    cli = {
      shells.fish.enable = true;

      editors = {
        nvim.enable = true;
      };

      programs = {
        git.enable = true;
        htop.enable = true;
      };
    };

    # TODO: move this to a separate module
    home.packages = with pkgs;
    with pkgs.custom; [
      monolisa
      lo-res

      src-cli

      (lib.hiPrio parallel)
      moreutils

      unzip
      zip
      gnupg
      e2fsprogs
      wget
      openssl

      python3
      rustup
    ];
  };
}
