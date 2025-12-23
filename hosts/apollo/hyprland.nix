{lib, ...}: {
  system.programs.hyprland.settings = {
    primary_monitor = "eDP-1";
  };

  environment.variables.GDK_SCALE = "2";

  programs.hyprland.settings = let
    # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
    accelpoints = "0.2144477506 0.000 0.307 0.615 1.077 1.539 2.002 2.505 3.208 3.910 4.613 5.315 6.018 6.720 7.423 8.125 8.828 9.530 10.233 10.935 12.387";
  in {
    monitor = [
      # "DP-1, preferred, auto-left, auto"
      # "DP-2, preferred, auto-left, auto"
      # "eDP-1, preferred, auto, 1.600000"
      ", preferred, auto, 2"
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
