{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.suites.server;
in {
  options.suites.server = {
    enable = mkEnableOption "Enable server configuration";
  };

  config = mkIf cfg.enable {
    hardware = {
      networking.enable = true;
    };

    services = {
      openssh.enable = true;
    };

    security = {
      sops.enable = true;
      polkit.enable = true;
    };

    system = {
      nix.enable = true;
      boot.enable = true;
      fonts.enable = true;
      impermanence.enable = false;
      locale.enable = true;
    };
  };
}
