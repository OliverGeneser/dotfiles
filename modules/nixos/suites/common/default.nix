{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.suites.common;
in {
  options.suites.common = {
    enable = mkEnableOption "Enable common configuration";
  };

  config = mkIf cfg.enable {
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      networking.enable = true;
    };

    services = {
      openssh.enable = true;
    };

    security = {
      sops.enable = true;
      yubikey.enable = true;
      polkit.enable = true;
    };

    system = {
      nix.enable = true;
      boot.enable = true;
      fonts.enable = true;
      impermanence.enable = true;
      locale.enable = true;
    };
  };
}
