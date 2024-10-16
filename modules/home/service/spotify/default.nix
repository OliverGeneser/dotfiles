{ config
, lib
, ...
}:
with lib; let
  cfg = config.service.spotify;
in
{
  options.service.spotify = {
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
