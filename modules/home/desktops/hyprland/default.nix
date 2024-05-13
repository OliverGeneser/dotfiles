{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktops.hyprland;
  inherit (config.colorScheme) palette;
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
in {
  imports = with inputs; [
    hyprland-nix.homeManagerModules.default
    ./config.nix
    ./windowrules.nix
    ./keybindings.nix
  ];

  options.desktops.hyprland = {
    enable = mkEnableOption "enable hyprland window manager";
  };

  # FIX: this hack to use nix catppuccin module: https://github.com/catppuccin/nix/issues/102
  options.wayland.windowManager.hyprland = {
    settings = mkEnableOption "enable hyprland window manager";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    xdg.configFile."hypr".recursive = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;

      reloadConfig = true;
      systemdIntegration = true;
      recommendedEnvironment = true;
      xwayland.enable = true;

      settings = {
        hypridle = {
          lockCmd = "pidof hyprlock || ${hyprlock}";
          beforeSleepCmd = "${hyprctl} dispatch dpms off";
          afterSleepCmd = "${hyprctl} dispatch dpms on && ${loginctl} lock-session";
          listeners = [
            {
              timeout = 300;
              onTimeout = "${loginctl} lock-session";
            }
            {
              timeout = 360;
              onTimeout = "${hyprctl} dispatch dpms off";
              onResume = "${hyprctl} dispatch dpms on";
            }
          ];
        };

        hyprpaper = {
          enable = true;
          preloads = [
            "${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"
          ];
          wallpapers = [", ${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"];
        };

        hyprlock = {
          enable = true;

          general = {
            disable_loading_bar = true;
            hide_cursor = true;
          };

          input-fields = [
            {
              size = {
                width = 300;
                height = 60;
              };
              outline_thickness = 4;
              dots_size = 0.2;
              dots_spacing = 0.2;
              dots_center = true;
              outer_color = "${palette.base0E}";
              inner_color = "${palette.base02}";
              font_color = "${palette.base05}";
              fade_on_empty = false;
              placeholder_text = ''<span foreground="##cdd6f4"><i>󰌾 Logged in as </i><span foreground="##cba6f7">$USER</span></span>'';
              hide_input = false;
              check_color = "${palette.base0E}";
              fail_color = "${palette.base08}";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              capslock_color = "${palette.base0A}";
              position = {
                x = -0;
                y = -35;
              };
              halign = "center";
              valign = "center";
            }
          ];

          labels = [
            {
              text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
              color = "${palette.base05}";
              font_size = 25;
              position = {
                x = -30;
                y = -150;
              };
              halign = "right";
              valign = "top";
            }
            {
              text = ''cmd[update:30000] echo "$(date +"%R")"'';
              color = "${palette.base05}";
              font_size = 90;
              position = {
                x = -30;
                y = 0;
              };
              halign = "right";
              valign = "top";
            }
          ];

          backgrounds = [
            {
              path = "${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}";
            }
          ];
        };

        config = {
          exec_once = [
            "dbus-update-activation-environment --systemd --all"
            "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
            "${pkgs.swaynotificationcenter}/bin/swaync"
            "${pkgs.kanshi}/bin/kanshi"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "${pkgs.pyprland}/bin/pypr"
            "${pkgs.clipse}/bin/clipse -listen"
            "solaar -w hide"
            #"[workspace 1 silent] mullvad-browser"
            #"[worlspace 3 float;tile;silent] wezterm start --always-new-process"
            # "[workspace 5 silent] webcord"
          ];
        };
      };
    };

    desktops.addons = {
      gtk.enable = true;
      qt.enable = true;
      kanshi.enable = true;
      rofi.enable = true;
      swaync.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;

      pyprland.enable = true;
      #      hyprpaper.enable = true;
      #      hyprlock.enable = true;
    };
  };
}
