{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  inherit (config.colorScheme) palette;
  cfg = config.cli.terminals.foot;
in {
  options.cli.terminals.foot = with types; {
    enable = mkBoolOpt false "enable foot terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;

      settings = {
        colors = {
          foreground = "${palette.base05}"; # Text
          background = "${palette.base00}"; # Base

          regular0 = "${palette.base03}"; # Surface 1
          regular1 = "${palette.base08}"; # red
          regular2 = "${palette.base0B}"; # green
          regular3 = "${palette.base0A}"; # yellow
          regular4 = "${palette.base0D}"; # blue
          regular5 = "f5c2e7"; # pink
          regular6 = "${palette.base0C}"; # teal
          regular7 = "bac2de"; # subtext 1

          bright0 = "${palette.base04}"; # Surface 2
          bright1 = "${palette.base08}"; # red
          bright2 = "${palette.base0B}"; # green
          bright3 = "${palette.base0A}"; # yellow
          bright4 = "${palette.base0D}"; # blue
          bright5 = "f5c2e7"; # pink
          bright6 = "${palette.base0C}"; # teal
          bright7 = "a6adc8"; # subtext 0
        };

        main = {
          term = "foot";
          font = "MonoLisa Nerd Font:size=14, JoyPixels:size=14";
          shell = "fish";
          pad = "30x30";
          selection-target = "clipboard";
        };

        scrollback = {
          lines = 10000;
        };
      };
    };
  };
}
