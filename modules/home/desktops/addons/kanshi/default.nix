{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.desktops.addons.kanshi;
in
{
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

      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = null;
              position = null;
              scale = 1.333333;
              transform = "normal";
            }
          ];
        }
        {
          profile.name = "undocked-zoomed";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = null;
              position = null;
              scale = 1.6;
              transform = "normal";
            }
          ];
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = null;
              position = null;
              scale = 1.333333;
              transform = "normal";
            }
            {
              criteria = "DP-1";
              status = "enable";
              mode = null;
              position = null;
              scale = 1.0;
              transform = "normal";
            }
          ];
        }
        {
          profile.name = "desktop";
          profile.outputs = [
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
        }
        {
          profile.name = "desktop2monitors";
          profile.outputs = [
            {
              criteria = "ASUSTek COMPUTER INC VG27A N8LMQS070105";
              position = "0,0";
              mode = "2560x1440@165Hz";
            }
            {
              criteria = "AOC 2778G5 F67G8BA000681";
              position = "320,-1080";
              mode = "1920x1080@60Hz";
            }
          ];
        }
      ];
    };
  };
}
