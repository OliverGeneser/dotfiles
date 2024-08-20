{ lib
, pkgs
, config
, inputs
, ...
}:
with lib;
with inputs; let
  cfg = config.suites.common;
in
{
  imports = [
    catppuccin.homeManagerModules.catppuccin
    nix-colors.homeManagerModule
  ];

  options.suites.common = {
    enable = mkEnableOption "Enable common configuration";
  };

  config = mkIf cfg.enable {
    colorscheme = nix-colors.colorSchemes.catppuccin-mocha;
    # catppuccin.flavour = "mocha";

    system = {
      nix.enable = true;
      fonts.enable = true;
    };

    cli = {
      terminals.wezterm.enable = true;
      terminals.foot.enable = true;
      shells.fish.enable = true;
    };

    suites = {
      guis.enable = true;
    };

    security = {
      sops.enable = true;
    };

    service = {
      ollama.enable = true;
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
        htop
        unzip
        zip
        gnupg

        showmethekey
        python3
        rustup
      ];
  };
}
