{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.immich;
in {
  options.services.custom.immich = with types; {
    enable = mkBoolOpt false "Enable Immich";
  };

  config = mkIf cfg.enable {
    hardware = {
      custom = {
        networking = {
          allowedTCPPorts = [2283 3003];
          allowedUDPPorts = [2283 3003];
        };
      };
    };

    systemd.services."immich-server".serviceConfig.PrivateDevices = lib.mkForce false;
    users.users.immich.extraGroups = ["video" "render"];

    services = {
      immich = {
        enable = true;
        port = 2283;
        group = "users";
        mediaLocation = "/mnt/storage/vault/immich";
      };
    };
  };
}
