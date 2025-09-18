{lib, ...}: {
  config = {
    system.programs.hyprland.settings = {
      primary_monitor = "DP-5";
    };

    environment.variables.GDK_SCALE = "1";

    programs.hyprland.settings = {
      monitor = [
        ", preferred, auto, auto"
        "Unknown-1, disable"
        "DP-5, 2560x1440@144, auto, auto, bitdepth, 10"
      ];

      input = {
        kb_layout = lib.mkForce "us,dk";
        kb_variant = "altgr-intl,";
        kb_options = "grp:alt_space_toggle,";

        accel_profile = lib.mkForce "";
      };

      misc = {
        vrr = lib.mkForce 0;
      };
    };
  };
}
