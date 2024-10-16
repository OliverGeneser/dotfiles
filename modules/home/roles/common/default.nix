{ lib
, pkgs
, config
, inputs
, ...
}:
with lib;
with inputs; let
  cfg = config.roles.common;
in
{
  imports = [
    catppuccin.homeManagerModules.catppuccin
    nix-colors.homeManagerModule
  ];

  options.roles.common = {
    enable = mkEnableOption "Enable common configuration";
  };

  config = mkIf cfg.enable {
    colorscheme = nix-colors.colorSchemes.catppuccin-mocha;
    # catppuccin.flavour = "mocha";

    system = {
      nix.enable = true;
    };

    cli = {
      terminals.wezterm.enable = true;
      terminals.foot.enable = true;
      shells.fish.enable = true;

      editors = { nvim.enable = true; };
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

    # TODO: move this to a separate module
    home.packages = with pkgs;
      with pkgs.custom; [
        monolisa

        keymapp
        powertop

        src-cli

        (lib.hiPrio parallel)
        moreutils
        nvtopPackages.amd
        unzip
        zip
        gnupg
        e2fsprogs
        wget

        showmethekey
        python3
        rustup
      ];
  };
}
