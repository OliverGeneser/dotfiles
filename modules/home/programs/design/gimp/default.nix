{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.design.gimp;
in {
  options.programs.design.gimp = {
    enable = mkEnableOption "Enable Gimp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
