{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.nextcloud;
in {
  options.services.custom.nextcloud = with types; {
    enable = mkBoolOpt false "Enable Nextcloud service";
  };

  config = mkIf cfg.enable {
    environment.etc."nextcloud-admin-pass".text = "PWD";

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "localhost";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
    };
  };
}
