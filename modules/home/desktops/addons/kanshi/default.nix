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
      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.25;
              status = "enable";
            }
          ];
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.25;
              status = "enable";
            }
            {
              criteria = "DP-1";
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
      ];
    };
  };
}
