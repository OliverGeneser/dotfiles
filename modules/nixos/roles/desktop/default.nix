{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.desktop;
in {
  options.roles.desktop = {
    enable = mkEnableOption "Enable desktop configuration";
  };

  config = mkIf cfg.enable {
    roles = {
      common.enable = true;
      desktop.addons = {
        thunar.enable = true;
      };
    };
    services = {
      custom = {
        vpn.enable = true;
        virtualisation.podman.enable = true;
        postgresql = {
          enable = true;
          databases = [];
        };
      };
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      logitechMouse.enable = true;
    };

    system = {
      #boot.plymouth = true;
    };

    cli.programs = {
      nh.enable = true;
      adb.enable = true;
      nix-ld.enable = true;
    };

    user = {
      name = "olivergeneser";
    };
  };
}
