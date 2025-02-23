{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.adb;
in {
  options.cli.programs.adb = with types; {
    enable = mkBoolOpt false "Whether or not to enable adb";
  };

  config = mkIf cfg.enable {
    programs.adb = {
      enable = true;
    };
  };
}
