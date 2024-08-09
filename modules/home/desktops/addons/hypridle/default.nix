{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktops.addons.hypridle;
in {
  options.desktops.addons.hypridle = with types; {
    enable = mkBoolOpt false "Whether to enable the hypridle";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "hyprctl dispatch dpms off";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 120; # 2.5min.
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl - s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl - r"; # monitor backlight restore.
          }
          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          {
            timeout = 120; # 2.5min.
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl - sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl - rd rgb:kbd_backlight"; # turn on keyboard backlight.
          }
          {
            timeout = 900;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
