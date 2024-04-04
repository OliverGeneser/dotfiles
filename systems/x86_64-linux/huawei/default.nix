{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  # Enable Bootloader
  system.boot.efi.enable = true;
  # system.boot.bios.enable = true;

  system.battery.enable = true; # Only for laptops, they will still work without it, just improves battery life

  environment.systemPackages = with pkgs; [
    # Any particular packages only for this host
  ];

  suites.common.enable = true; # Enables the basics, like audio, networking, ssh, etc.

  networking.hostName = "huawei";
  swapDevices = [{device = "/swap/swapfile";}];

  boot = {
    kernelParams = [
      "resume_offset=533760"
    ];
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
    initrd.systemd.enable = true;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
