{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.libreoffice;
in {
  options.programs.libreoffice = {
    enable = mkEnableOption "Enable libreoffice program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-fresh
    ];
  };
}
