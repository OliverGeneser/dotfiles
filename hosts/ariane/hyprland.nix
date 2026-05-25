{ lib, ... }:
{
  environment.variables.GDK_SCALE = "1";

  programs.hyprland.settings =
    let
      # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
      accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
    in
    {
      monitor = [
        ", preferred, auto, 2"
      ];

      input = {
        kb_layout = lib.mkForce "us";
        kb_variant = "altgr-intl";
        kb_options = "grp:alt_space_toggle";
      };

      "device[elan06d4:00-04f3:32b5-touchpad]" = {
        accel_profile = "custom ${accelpoints}";
        scroll_points = accelpoints;
        natural_scroll = true;
      };
    };
}
