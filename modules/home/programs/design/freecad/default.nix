{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.design.freecad;
in {
  options.programs.design.freecad = {
    enable = mkEnableOption "Enable FreeCAD";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freecad
    ];
  };
}
