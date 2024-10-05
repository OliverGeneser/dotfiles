{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.roles.laptop;
in {
  options.roles.laptop = {
    enable = mkEnableOption "Enable laptop configuration";
  };

  config = mkIf cfg.enable {
    services.thermald.enable = true;

    hardware = {
      batteryctl.enable = true;
    };
  };
}
