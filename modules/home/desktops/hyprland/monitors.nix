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
      monitor =
        [
          # "HDMI-A-1,addreserved,0,0,0,150"
          "Unknown-1, disable"
        ]
        ++ cfg.extra_monitors;

      exec-once = [
        "[workspace 3 silent] wezterm"
        "[workspace 5 silent] webcord"
      ];

      workspace =
        [
          "1, monitor:${cfg.primary_monitor}, on-created-empty:[silent] zen-twilight --new-instance, default:true"
          "2, monitor:${cfg.primary_monitor}, on-created-empty:[silent] zen-twilight --new-instance"
          "3, monitor:${cfg.primary_monitor}, on-created-empty:[silent] wezterm"
          "4, monitor:${cfg.primary_monitor}"
          "5, monitor:${cfg.primary_monitor}, on-created-empty:[silent] webcord"
          "6, monitor:${cfg.primary_monitor}"
          "7, monitor:${cfg.primary_monitor}"
          "8, monitor:${cfg.primary_monitor}"
          "9, monitor:${cfg.primary_monitor}"
        ]
        ++ cfg.extra_monitors_workspace;
    };
  };
}
