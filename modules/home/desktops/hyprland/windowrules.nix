{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  rule = rules: attrs: attrs // {inherit rules;};
  cfg = config.desktops.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.windowRules = let
      mullvadVideo = {
        class = ["Mullvad Browser"];
      };
      bitwarden = {
        title = [".*Bitwarden.*"];
      };
    in
      lib.concatLists [
        (map (rule ["idleinhibit fullscreen"]) [mullvadVideo])
        (map (rule ["float"]) [bitwarden])
      ];
  };
}
