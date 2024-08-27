{ inputs
, pkgs
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  networking = {
    hostName = "huawei";
  };

  services.thermald.enable = true;
  hardware.nvidia.open = lib.mkForce false;

  suites = {
    gaming.enable = true;
    desktop = {
      enable = true;
      addons = {
        hyprland.enable = true;
      };
    };
  };

  boot = {
    kernelParams = [
      "resume_offset=533760"
    ];
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  systemd.services.my-power-service = {
    description = "Custom service for power supply values";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-cryptsetup@cryptroot.service" ];
    serviceConfig = {
      ExecStart = "/bin/sh -c 'echo \"70 80\" > /sys/devices/platform/huawei-wmi/charge_control_thresholds';/bin/sh -c 'echo 70 > /sys/class/power_supply/BAT0/charge_control_start_threshold';/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
      Type = "oneshot";
    };
  };

  system.stateVersion = "23.11";
}
