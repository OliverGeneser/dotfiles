{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.custom.services.radarr;
in {
  options.custom.services.radarr = with types; {
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
