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
      "1, on-created-empty:[float] firefox"
      "3, on-created-empty:[float] foot"
    ];
  };
}
