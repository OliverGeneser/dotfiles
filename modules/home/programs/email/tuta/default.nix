{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.email.tuta;
in {
  options.programs.email.tuta = {
    enable = mkEnableOption "Enable tuta";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tutanota-desktop
    ];
  };
}
