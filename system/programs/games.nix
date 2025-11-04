{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.custom-udev-rules.nixosModule
  ];

  hardware = {
    xpadneo.enable = true;
    xone.enable = true;
  };

  boot.kernel.sysctl = {
    # 20-shed.conf
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    # 20-net-timeout.conf
    # This is required due to some games being unable to reuse their TCP ports
    # if they're killed and restarted quickly - the default timeout is too large.
    "net.ipv4.tcp_fin_timeout" = 5;
    # 30-vm.conf
    # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
    # see comment in include/linux/mm.h in the kernel tree.
    "vm.max_map_count" = 2147483642;
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--adaptive-sync" # VRR support
        "--hdr-enabled"
        "--rt"
        "--expose-wayland"
      ];
    };

    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];

      gamescopeSession.enable = true;
    };
  };

  services.udev.customRules = [
    {
      name = "99-8bitdo-xinput";
      rules = ''
        ACTION=="add", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="310a", RUN+="/sbin/modprobe xpad", RUN+="/bin/sh -c 'echo 2dc8 310a > /sys/bus/usb/drivers/xpad/new_id'"
      '';
    }
  ];

  environment.systemPackages = [inputs.prismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher];
}
