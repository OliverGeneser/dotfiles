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
    };
  };
}
