{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.suites.laptop;
in {
  options.suites.laptop = {
    enable = mkEnableOption "Enable laptop configuration";
  };

  config = mkIf cfg.enable {
    services.thermald.enable = true;

    hardware = {
      batteryctl.enable = true;
    };
  };
}
