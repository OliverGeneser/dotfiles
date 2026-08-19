{ self, ... }: {
  environment.variables.GDK_SCALE = "1";
  environment.etc."xdg/hypr/per_host.lua".text = ''
    hl.config({
      input = {
        kb_layout = "us,dk",
        kb_variant = "altgr-intl,",
        kb_options = "grp:alt_space_toggle,",
      }
    })
    hl.monitor({
      output   = "DP-5",
      mode = "2560x1440@144",
      position = "auto",
      scale    = "auto",
      bitdepth = 10,
    })
  '';
}
