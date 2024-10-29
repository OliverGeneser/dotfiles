{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.arduino;
in
{
  options.programs.arduino = {
    enable = mkEnableOption "Enable Arduino";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arduino-ide
    ];
  };
}
