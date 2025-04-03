{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.styles.stylix;
in {
  imports = with inputs; [
    stylix.homeManagerModules.stylix
    catppuccin.homeModules.catppuccin
  ];

  options.styles.stylix = {
    enable = lib.mkEnableOption "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.symbols-only
      open-sans
      plemoljp
    ];

    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      image = pkgs.custom.wallpapers.gfda_34-black_5120x2880;

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      fonts = {
        sizes = {
          terminal = 14;
          applications = 12;
          popups = 12;
        };

        serif = {
          name = "Source Serif";
          package = pkgs.source-serif;
        };

        sansSerif = {
          name = "Noto Sans";
          package = pkgs.noto-fonts;
        };

        monospace = {
          package = pkgs.custom.monolisa;
          name = "MonoLisa Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
