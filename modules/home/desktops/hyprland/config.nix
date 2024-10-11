{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.desktops.hyprland;
  inherit (config.colorScheme) palette;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = cfg.layout;
        kb_variant = cfg.variant;
        kb_options = cfg.options;
        follow_mouse = true;
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
        #col.active_border = "0xff${palette.base07}";
        #col.inactive_border = "0xff${palette.base02}";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
      };

      misc = {
        vrr = 2;
        vfr = 1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        disable_autoreload = true;
      };

      # <https://wiki.hyprland.org/Configuring/Dwindle-Layout/>
      dwindle = {
        pseudotile = true;
        preserve_split = true; # false
        no_gaps_when_only = true;
      };

      plugin = {
        csgo-vulkan-fix = {
          res_w = 1280;
          res_h = 1024;

          # NOT a regex! This is a string and has to exactly match initial_class
          class = "cs2";

          # Whether to fix the mouse position. A select few apps might be wonky with this.
          fix_mouse = true;
        };
      };

      exec-once = [
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE"
        "${pkgs.swaynotificationcenter}/bin/swaync"
        #"${pkgs.kanshi}/bin/kanshi"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.pyprland}/bin/pypr"
        "${pkgs.clipse}/bin/clipse -listen"
        "${pkgs.solaar}/bin/solaar -w hide"
      ];
    };
  };
}
