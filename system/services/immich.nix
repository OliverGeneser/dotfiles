{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.firewall = {
    allowedTCPPorts = [ 2283 ];
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      group = "users";
      accelerationDevices = null;
      mediaLocation = "/mnt/storage/vault/immich";
    };
  };
}
