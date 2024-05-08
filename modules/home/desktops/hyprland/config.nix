{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.hyprland;
  inherit (config.colorScheme) palette;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      config = {
        monitor = [ "HDMI-A-1,addreserved,0,0,0,150" ];
        
        workspace = [
          "1, monitor:DP-1, on-created-empty:[silent,fullscreen] mullvadbrowser"
          "2, monitor:DP-1, on-created-empty:[silent,fullscreen] firefox"
          "3, monitor:DP-1, on-created-empty:[silent,fullscreen] wezterm"
          "4, monitor:DP-1"
          "5, monitor:DP-1, on-created-empty:[silent,fullscreen] webcord"
          "6, monitor:DP-1, on-created-empty:[silent,fullscreen] gimp"
          "7, monitor:DP-1"
          "8, monitor:DP-1"
          "9, monitor:DP-1"
          "0, monitor:DP-1"
        ];

        input = {
          kb_layout = "us,dk";
          kb_variant = "altgr-intl,";
          kb_options = "grp:alt_space_toggle,";
          touchpad = {
            disable_while_typing = false;
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 0;
          active_border_color = "0xff${palette.base07}";
          inactive_border_color = "0xff${palette.base02}";
        };

        decoration = {
          rounding = 8;
        };

        misc = let
          FULLSCREEN_ONLY = 2;
        in {
          vrr = 2;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          variable_framerate = true;
          variable_refresh = FULLSCREEN_ONLY;
          disable_autoreload = true;
        };
      };
    };
  };
}
