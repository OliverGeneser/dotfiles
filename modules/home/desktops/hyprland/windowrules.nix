{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.windowrulev2 = [
      "idleinhibit fullscreen,class:(Mullvad Browser)"
      "fullscreen,title:(.*Bitwarden.*)"
    ];

    wayland.windowManager.hyprland.settings.workspace = [
      "1, monitor:eDP-1, on-created-empty:[silent] firefox"
      "3, monitor:eDP-1, on-created-empty:[silent] foot"
      "5, monitor:eDP-1, on-created-empty:[silent] webcord"
    ];
  };
}
