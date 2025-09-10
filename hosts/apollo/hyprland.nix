{lib, ...}: {
  system.programs.hyprland.settings = {
    primary_monitor = "eDP-1";
  };

  environment.variables.GDK_SCALE = "2";

  programs.hyprland.settings = let
    # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
    accelpoints = "0.5 0.000 0.513 1.055 1.629 2.240 2.891 3.585 4.327 5.120 5.968 6.875 7.844 8.880 9.986 11.165 12.422 13.760 15.183 16.695 18.299";
  in {
    monitor = [
      # "DP-1, preferred, auto-left, auto"
      # "DP-2, preferred, auto-left, auto"
      # "eDP-1, preferred, auto, 1.600000"
      ", preferred, auto, auto"
    ];

    input = {
      kb_layout = lib.mkForce "dk,us";
      kb_variant = ",altgr-intl";
      kb_options = ",grp:alt_space_toggle";
    };

    "device[syna1d31:00-06cb:cd48-touchpad]" = {
      accel_profile = "custom ${accelpoints}";
      scroll_points = accelpoints;
      natural_scroll = true;
    };
  };
}
