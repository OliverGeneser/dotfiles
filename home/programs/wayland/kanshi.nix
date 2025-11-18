{
  pkgs,
  lib,
  ...
}: {
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
            scale = 2.0;
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
            scale = 2.0;
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
            criteria = "DP-2";
            position = "0,0";
            scale = 1.0;
            mode = "2560x1440@144Hz";
          }
          {
            criteria = "HDMI-A-1";
            position = "320,-1080";
            scale = 1.0;
            mode = "1920x1080@60Hz";
          }
        ];
      }
      {
        profile.name = "desktop-fix";
        profile.outputs = [
          {
            criteria = "DP-5";
            position = "0,0";
            scale = 1.0;
            mode = "2560x1440@144Hz";
          }
          {
            criteria = "HDMI-A-2";
            position = "320,-1080";
            scale = 1.0;
            mode = "1920x1080@60Hz";
          }
        ];
      }
    ];
  };
}
