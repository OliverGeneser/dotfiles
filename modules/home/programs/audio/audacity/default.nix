{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.audio.audacity;
in
{
  options.programs.audio.audacity = {
    enable = mkEnableOption "Enable Audacity";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      audacity
    ];
  };
}
