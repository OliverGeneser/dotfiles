{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [2283 3003];
    allowedUDPPorts = [2283 3003];
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
}
