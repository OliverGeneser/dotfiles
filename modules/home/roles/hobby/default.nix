{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.roles.hobby;
in {
  options.roles.hobby = {
    enable = mkEnableOption "Enable hobby configuration";
  };

  config = mkIf cfg.enable {
    programs.printing.super-slicer.enable = true;
    #programs.design.freecad.enable = true;
  };
}
