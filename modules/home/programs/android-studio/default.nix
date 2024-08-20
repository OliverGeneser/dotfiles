{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.androidStudio;
in
{
  options.programs.androidStudio = {
    enable = mkEnableOption "Enable Android Studio";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      android-tools
      android-studio
    ];
  };
}
