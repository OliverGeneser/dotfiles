{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.bitwarden;
in {
  options.programs.bitwarden = {
    enable = mkEnableOption "Enable bitwarden program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
    
    services.gnome-keyring.enable = true;

  };
}
