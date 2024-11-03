{ config
, lib
, ...
}:
with lib; let
  cfg = config.desktops.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        # "HDMI-A-1,addreserved,0,0,0,150"
      ];

      exec-once = [
        "[workspace 1 silent] firefox --new-instance --new-window localhost:8008"
        "[workspace 3 silent] wezterm connect unix"
        "[workspace 5 silent] webcord"
      ];

      workspace = [
        "1, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] firefox --new-instance"
        "2, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] firefox --new-instance --new-window localhost:8008"
        "3, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] wezterm connect unix"
        "4, monitor:${cfg.primary_monitor}"
        "5, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] webcord"
        "6, monitor:${cfg.primary_monitor}"
        "7, monitor:${cfg.primary_monitor}"
        "8, monitor:${cfg.primary_monitor}"
        "9, monitor:${cfg.primary_monitor}"
        "0, monitor:${cfg.primary_monitor}"
      ];
    };
  };
}
