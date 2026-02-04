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
        profile.name = "docked-work-oliver";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = null;
            scale = 1.0;
            transform = "normal";
            position = null;
          }
          {
            criteria = "Dell Inc. DELL P3425WE 6S0SY54";
            status = "enable";
            mode = "3440x1440@60hz";
            scale = 1.0;
            transform = "normal";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "docked-alex";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = null;
            scale = 2.0;
            transform = "normal";
            position = "0,0";
          }
          {
            criteria = "Lenovo Group Limited LEN T32p-20 VNA735K6";
            status = "enable";
            mode = null; #"2560x1440@60Hz";
            scale = 2.0;
            transform = "normal";
            position = "-2560,0";
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
            scale = 2.0;
            transform = "normal";
            position = null;
          }
          {
            criteria = "DP-1";
            status = "enable";
            mode = null;
            scale = 1.0;
            transform = "normal";
            position = "0,0";
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
