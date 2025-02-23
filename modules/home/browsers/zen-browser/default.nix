{
  pkgs,
  inputs,
  lib,
  options,
  config,
  system,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.browsers.zen;
in {
  options.browsers.zen = with types; {
    enable = mkBoolOpt false "Enable or disable zen browser";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = ["Zen.desktop"];
      "text/xml" = ["Zen.desktop"];
      "x-scheme-handler/http" = ["Zen.desktop"];
      "x-scheme-handler/https" = ["Zen.desktop"];
    };

    home.packages = [
      inputs.zen-browser.packages."${system}".twilight
    ];
  };
}
