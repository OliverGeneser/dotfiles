{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.custom.services.nextcloud;
in {
  options.custom.services.nextcloud = with types; {
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
