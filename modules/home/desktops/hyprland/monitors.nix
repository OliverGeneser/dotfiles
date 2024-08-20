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
        "HDMI-A-1,addreserved,0,0,0,150"
      ];

      exec-once = [
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] firefox"
        "[workspace 3 silent] wezterm start --always-new-process"
        "[workspace 5 silent] webcord"
      ];

      workspace = [
        "1, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] firefox"
        "2, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] firefox"
        "3, monitor:${cfg.primary_monitor}, on-created-empty:[silent,fullscreen] wezterm start --always-new-process"
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
