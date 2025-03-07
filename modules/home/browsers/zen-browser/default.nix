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
  zen-browser = inputs.zen-browser.packages.${system}.twilight;
  cfg = config.browsers.zen;
in {
  options.browsers.zen = with types; {
    enable = mkBoolOpt false "Enable or disable zen browser";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DEFAULT_BROWSER = "${zen-browser}/bin/zen-twilight";
    };

    home.packages = [
      zen-browser
    ];

    xdg.mimeApps = let
      associations = builtins.listToAttrs (map (name: {
          inherit name;
          value = zen-browser.meta.desktopFile;
        }) [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "text/html"
        ]);
    in {
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
