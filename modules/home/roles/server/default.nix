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
      terminals.wezterm.enable = true;

      editors = {
        nvim.enable = true;
      };

      programs = {
        git.enable = true;
        htop.enable = true;
        eza.enable = true;
        fzf.enable = true;
        modern-unix.enable = true;
        nix-index.enable = true;
        direnv.enable = true;
      };
    };

    styles.stylix.enable = true;

    # TODO: move this to a separate module
    home.packages = with pkgs; [
      src-cli

      (hiPrio parallel)
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
