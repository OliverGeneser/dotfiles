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
    hostName = "workstation";
  };

  services.thermald.enable = true;
  hardware = {
    networking = {
      allowedTCPPortRanges = [{ from = 1714; to = 1764; } { from = 19000; to = 19001; }];
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
      allowedTCPPorts = [ 3000 8081 ];
    };
    nvidia.enable = true;
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
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_6_10; #https://github.com/NixOS/nixpkgs/issues/344167
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "23.11";
}
