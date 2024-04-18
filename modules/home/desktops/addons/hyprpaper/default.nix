{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktops.addons.hyprpaper;
  inherit (inputs) hyprpaper;
in {
  imports = [hyprpaper.homeManagerModules.default];

  options.desktops.addons.hyprpaper = with types; {
    enable = mkBoolOpt false "Whether to enable the hyprpaper config";
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      preloads = [
        "${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"
      ];
      wallpapers = [", ${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"];
    };
  };
}
