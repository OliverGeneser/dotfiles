{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; {
  imports = with inputs.nixos-hardware.nixosModules; [
    raspberry-pi-3
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "tunnelboy";
  };

  system = {
    boot.enable = lib.mkForce false;
    impermanence.enable = lib.mkForce false;
  };

  roles = {
    server.enable = true;
  };

  environment.systemPackages = with pkgs; [vim];

  systemd = {
    # For more detail, see:
    #   https://0pointer.de/blog/projects/watchdog.html
    watchdog = {
      # systemd will send a signal to the hardware watchdog at half
      # the interval defined here, so every 10s.
      # If the hardware watchdog does not get a signal for 20s,
      # it will forcefully reboot the system.
      runtimeTime = lib.mkForce null;
      # Forcefully reboot if the final stage of the reboot
      # hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      rebootTime = lib.mkForce null;
    };
  };

  sdImage.compressImage = false;

  system.stateVersion = "23.11";
}
