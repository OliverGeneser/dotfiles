{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.terminals.foot;
in {
  options.cli.terminals.foot = with types; {
    enable = mkBoolOpt false "enable foot terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;

      catppuccin.enable = true;

      settings = {
        main = {
          term = "foot";
          font = "MonoLisa Nerd Font:size=14, JoyPixels:size=14";
          shell = "fish";
          pad = "15x15";
          selection-target = "clipboard";
        };

        scrollback = {
          lines = 10000;
        };
      };
    };
  };
}
