{lib, ...}: {
  config = {
    system.programs.hyprland.settings = {
      primary_monitor = "DP-5";
    };

    programs.hyprland.settings = {
      monitor = [
        "Unknown-1, disable"
        "DP-5, 2560x1440@144, auto, 1"
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
