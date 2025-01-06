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
    sops.secrets.nextcloud_admin_password = {
      owner = "nextcloud";
      group = "nextcloud";
      sopsFile = ../secrets.yaml;
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "localhost";
      config.adminpassFile = config.sops.secrets.nextcloud_admin_password.path;
    };
  };
}
