{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.desktop;
in {
  options.suites.desktop = {
    enable = mkEnableOption "Enable desktop configuration";
  };

  config = mkIf cfg.enable {
    suites = {
      common.enable = true;

      desktop.addons = {
        nautilus.enable = true;
      };
    };

    hardware = {
      logitechMouse.enable = true;
    };

    virtualisation = {
      podman.enable = true;
    };

    services = {
      vpn.enable = true;
      virtualisation.podman.enable = true;
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
