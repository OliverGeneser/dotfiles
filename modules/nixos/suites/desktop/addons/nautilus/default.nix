{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.desktop.addons.nautilus;
in {
  options.suites.desktop.addons.nautilus = with types; {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    programs.dconf.enable = true;

    environment = {
      sessionVariables = {
        NAUTILUS_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
        NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
        GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
          gst-libav
        ]);
      };

      pathsToLink = [
        "/share/nautilus-python/extensions"
      ];

      systemPackages = with pkgs; [
        ffmpegthumbnailer # thumbnails
        gst_all_1.gst-libav # thumbnails
        nautilus-open-any-terminal
        nautilus-python
      ];
    };

    snowfallorg.users.${config.user.name}.home.config = {
      dconf.settings = {
        "org/gnome/desktop/privacy" = {
          remember-recent-files = false;
        };
      };
    };
  };
}
