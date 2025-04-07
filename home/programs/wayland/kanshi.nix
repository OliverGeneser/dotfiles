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
            criteria = "DP-5";
            position = "0,0";
            mode = "2560x1440@144Hz";
          }
          {
            criteria = "HDMI-A-2";
            position = "320,-1080";
            mode = "1920x1080@60Hz";
          }
        ];
      }
    ];
  };
}
