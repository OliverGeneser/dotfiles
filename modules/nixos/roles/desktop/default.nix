{ lib
, config
, ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = {
    enable = mkEnableOption "Enable desktop configuration";
  };

  config = mkIf cfg.enable {
    roles = {
      common.enable = true;

      desktop.addons = {
        nautilus.enable = true;
      };
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      logitechMouse.enable = true;
    };

    services = {
      vpn.enable = true;
      virtualisation.podman.enable = true;
    };

    system = {
      #boot.plymouth = true;
    };

    cli.programs = {
      nix-ld.enable = true;
    };

    user = {
      name = "olivergeneser";
      initialPassword = "test1234";
    };
  };
}
