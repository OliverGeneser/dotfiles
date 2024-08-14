{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "HDMI-A-1,addreserved,0,0,0,150"
      ];

      workspace = [
        "1, monitor:${cfg.primary_monitor}, on-created-empty:[silent] firefox"
        "2, monitor:${cfg.primary_monitor}, on-created-empty:[silent] firefox"
        "3, monitor:${cfg.primary_monitor}, on-created-empty:[silent] foot"
        "5, monitor:${cfg.primary_monitor}, on-created-empty:[silent] webcord"
      ];
    };
  };
}
