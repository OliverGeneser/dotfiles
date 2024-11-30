{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.beekeeperStudio;
in {
  options.programs.beekeeperStudio = {
    enable = mkEnableOption "Enable Beekeeper studio";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      beekeeper-studio
    ];
  };
}
