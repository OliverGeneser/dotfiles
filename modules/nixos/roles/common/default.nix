{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.roles.common;
in {
  options.roles.common = {
    enable = mkEnableOption "Enable common configuration";
  };

  config = mkIf cfg.enable {
    hardware = {
      custom = {
        networking.enable = true;
      };
    };

    services = {
      custom = {
        ssh.enable = true;
      };
    };

    security = {
      custom = {
        sops.enable = true;
        yubikey.enable = true;
      };
    };

    styles.stylix.enable = true;

    system = {
      nix.enable = true;
      boot.enable = true;
      impermanence.enable = true;
      locale.enable = true;
    };
  };
}
