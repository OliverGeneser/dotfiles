{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.radarr;
in {
  options.services.custom.radarr = with types; {
    enable = mkBoolOpt false "Enable Radarr";
  };

  config = mkIf cfg.enable {
    services = {
      radarr = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
