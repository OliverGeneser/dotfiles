{
  pkgs,
  self,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./hyprland.nix
    ./nvidia.nix
    ./powersave.nix
    inputs.nixos-hardware.nixosModules.huawei-machc-wa
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
    resumeDevice = "/dev/disk/by-label/nixos";
    # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
    kernelParams = [
      "resume_offset=533760"
    ];
  };

  # nh default flake
  environment.variables.NH_FLAKE = "/home/olivergeneser/dotfiles";

  networking = {
    hostName = "apollo";
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };

  systemd.services.my-power-service = {
    description = "Custom service for power supply values";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "/bin/sh -c 'echo \"70 80\" > /sys/devices/platform/huawei-wmi/charge_control_thresholds';/bin/sh -c 'echo 70 > /sys/class/power_supply/BAT0/charge_control_start_threshold';/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
      Type = "oneshot";
    };
  };
}
