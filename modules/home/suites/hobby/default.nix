{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.suites.hobby;
in {
  options.suites.hobby = {
    enable = mkEnableOption "Enable hobby configuration";
  };

  config = mkIf cfg.enable {
    programs.printing.super-slicer.enable = true;
  };
}
