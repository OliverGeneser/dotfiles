{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktops.hyprland;
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
      };

      config = {
        exec_once = [
          "dbus-update-activation-environment --systemd --all"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
          "${pkgs.swaynotificationcenter}/bin/swaync"
          "${pkgs.kanshi}/bin/kanshi"
          #         "${pkgs.waybar}/bin/waybar"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "${pkgs.pyprland}/bin/pypr"
          "${pkgs.clipse}/bin/clipse -listen"
          "solaar -w hide"
          "[workspace 1 silent] mullvad-browser"
          "[worlspace 3 float;tile;silent] wezterm start --always-new-process"
          "[workspace 5 silent] webcord"
        ];
      };
    };
    #  xdg.configFile."hypr".recursive = true;

    desktops.addons = {
      gtk.enable = true;
      qt.enable = true;
      kanshi.enable = true;
      rofi.enable = true;
      swaync.enable = true;
      #      waybar.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;

      pyprland.enable = true;
      hyprpaper.enable = true;
      hyprlock.enable = true;
      #hypridle.enable = true;
    };
  };
}
