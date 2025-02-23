{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.guis;
in {
  options.programs.guis = {
    enable = mkEnableOption "Enable gnome adwaita GUI applications";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ## VPN
      trayscale

      ## Ebook
      foliate

      ## Audio
      pwvucontrol

      gnome-disk-utility
      loupe
    ];

    xdg.configFile."com.github.johnfactotum.Foliate/themes/mocha.json".text = ''
      {
          "label": "Mocha",
          "light": {
          	"fg": "#999999",
          	"bg": "#cccccc",
          	"link": "#666666"
          },
          "dark": {
          	"fg": "#cdd6f4",
          	"bg": "#1e1e2e",
          	"link": "#E0DCF5"
          }
      }
    '';
  };
}
