{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.custom.spotify;
in {
  options.services.custom.spotify = {
    enable = mkEnableOption "Enable spotify service";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # spotify-tui
    ];

    # services.spotifyd = {
    #   enable = true;
    # };
  };
}
