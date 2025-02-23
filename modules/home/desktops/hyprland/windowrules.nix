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
      "tile, class:^(org.wezfurlong.wezterm)$"

      "tile, class:(firefox)"

      "tile, class:(Mullvad Browser)"

      "tile, class:(zen-twilight)"
      "float, title:(Picture-in-Picture)"
      "fullscreenstate 0 *, title:(Picture-in-Picture)"
      "size 25% 25%, title:(Picture-in-Picture)"
      "move 100%-w-5 100%-w-5, title:(Picture-in-Picture)"

      "float, title:(Extension: (Bitwarden Password Manager))(.*)"
      "fullscreen, class:(cs2)"
    ];
  };
}
