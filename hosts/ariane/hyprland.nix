{ self, ... }: {
  environment.variables.GDK_SCALE = "1";
  environment.etc."xdg/hypr/per_host.lua".text =
    let
      # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
      accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
    in
    ''
          hl.config({
            input = {
              kb_layout = "us",
              kb_variant = "altgr-intl",
              kb_options = "grp:alt_space_toggle",
            }
          })

      hl.device({
              name            = "device[elan06d4:00-04f3:32b5-touchpad]",
              accel_profile   = "custom ${accelpoints}",
              scroll_points   = "${accelpoints}",
              natural_scroll  = true,
            })

      -- Positive-only layout (no negative origin):
      -- Lenovo left  (2560 wide) at 0x0
      -- Dell middle   (3440 wide) at 2560x0
      -- eDP-1 right   (1920 wide) at 6000x0 (2560+3440)
      -- Use desc: prefix: DP-1/DP-3 connector names are unstable.
      hl.monitor({
        output   = "desc:Lenovo Group Limited LEN P27h-10",
        mode     = "2560x1440@59.95",
        position = "0x0",
        scale    = 1,
      })
      hl.monitor({
        output   = "desc:Dell Inc. DELL P3425WE",
        mode     = "3440x1440@99.98",
        position = "2560x0",
        scale    = 1,
      })
      hl.monitor({
        output   = "eDP-1",
        mode     = "1920x1200@60",
        position = "6000x0",
        scale    = 1,
      })
    '';
}
