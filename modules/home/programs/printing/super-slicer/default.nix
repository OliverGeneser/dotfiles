{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.printing.super-slicer;
in {
  options.programs.printing.super-slicer = {
    enable = mkEnableOption "Enable superslicer";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      super-slicer-beta
    ];
  };
}
