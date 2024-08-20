{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.desktops.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.windowrulev2 = [
      "idleinhibit fullscreen,class:(Mullvad Browser)"
      "fullscreen,title:(.*Bitwarden.*)"
      "float,class:^(org.wezfurlong.wezterm)$"
      "tile,class:^(org.wezfurlong.wezterm)$"
    ];
  };
}
