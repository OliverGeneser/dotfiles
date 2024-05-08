{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.addons.kanshi;
in {
  options.desktops.addons.kanshi = {
    enable = mkEnableOption "Enable kanshi display addon";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kanshi
    ];

    services.kanshi = {
      enable = true;
      package = pkgs.kanshi;
      systemdTarget = "hyprland-session.target";
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.0;
              status = "enable";
            }
          ];
        };

        desktop = {
          outputs = [
            {
              criteria = "DP-1";
              position = "0,0";
              mode = "2560x1440@165Hz";
            }
            {
              criteria = "HDMI-A-1";
              position = "-1920,180";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "DVI-D-1";
              position = "320,-1080";
              mode = "1920x1080@60Hz";
            }
          ];
        };
      };
    };
  };
}
