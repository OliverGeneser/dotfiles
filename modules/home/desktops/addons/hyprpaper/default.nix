{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktops.addons.hyprpaper;
in {
  options.desktops.addons.hyprpaper = with types; {
    enable = mkBoolOpt false "Whether to enable the hyprpaper config";
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"
        ];
        wallpaper = [", ${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"];
      };
    };
  };
}
