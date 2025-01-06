{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  networking = {
    hostName = "workstation";
  };

  system = {
    impermanence = {
      usesEncryption = lib.mkForce true;
    };
  };

  services = {
    thermald.enable = true;
  };

  hardware = {
    networking = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        {
          from = 19000;
          to = 19001;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedTCPPorts = [80 443 3000 8081 4321];
    };
    custom = {
      nvidia.enable = true;
    };
  };

  roles = {
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
    supportedFilesystems = lib.mkForce ["btrfs" "ntfs"];
    kernelPackages = pkgs.linuxPackages_latest; #https://github.com/NixOS/nixpkgs/issues/344167
    resumeDevice = "/dev/disk/by-label/nixos";
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  system.stateVersion = "23.11";
}
