{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.unityhub;
in
{
  options.programs.unityhub = {
    enable = mkEnableOption "Enable Unity hub";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unityhub
    ];
  };
}
