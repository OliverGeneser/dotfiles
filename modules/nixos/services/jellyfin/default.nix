{ config
, pkgs
, lib
, ...
}:
with lib;
with lib.custom; let
  cfg = config.services.jellyfin-server;
in
{
  options.services.jellyfin-server = with types; {
    enable = mkBoolOpt false "Enable Jellyfin";
  };

  config = mkIf cfg.enable {
    hardware = {
      vaapi.enable = true;
    };

    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
    };

    environment = {
      systemPackages = [
        pkgs.jellyfin
        pkgs.jellyfin-web
        pkgs.jellyfin-ffmpeg
      ];
    };
  };
}
