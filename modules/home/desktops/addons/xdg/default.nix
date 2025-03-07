{
  config,
  lib,
  inputs,
  system,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktops.addons.xdg;
in {
  options.desktops.addons.xdg = with types; {
    enable = mkBoolOpt false "manage xdg config";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      HISTFILE = lib.mkForce "${config.xdg.stateHome}/bash/history";
      #GNUPGHOME = lib.mkForce "${config.xdg.dataHome}/gnupg";
      GTK2_RC_FILES = lib.mkForce "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";

      mimeApps = {
        enable = true;
        associations.added = {
          "video/mp4" = ["org.gnome.Totem.desktop"];
          "video/quicktime" = ["org.gnome.Totem.desktop"];
          "video/webm" = ["org.gnome.Totem.desktop"];
          "video/x-matroska" = ["org.gnome.Totem.desktop"];
          "image/gif" = ["org.gnome.Loupe.desktop"];
          "image/png" = ["org.gnome.Loupe.desktop"];
          "image/jpg" = ["org.gnome.Loupe.desktop"];
          "image/jpeg" = ["org.gnome.Loupe.desktop"];
        };
        defaultApplications = {
          "audio/*" = ["mpv.desktop"];
          "video/*" = ["org.gnome.Totem.desktop"];
          "video/mp4" = ["org.gnome.Totem.desktop"];
          "video/x-matroska" = ["org.gnome.Totem.desktop"];
          "image/*" = ["org.gnome.loupe.desktop"];
          "image/png" = ["org.gnome.loupe.desktop"];
          "image/jpg" = ["org.gnome.loupe.desktop"];
          "application/json" = ["nvim.desktop"];
          "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
          "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
          "application/toml" = ["nvim.desktop"];
          "text/plain" = ["nvim.desktop"];
        };
      };

      userDirs = let
        home = config.home.homeDirectory;
      in {
        enable = true;
        createDirectories = true;

        desktop = null;
        download = "${home}/Downloads";
        documents = "${home}/Documents";
        pictures = "${home}/Pictures";
        music = null;
        publicShare = null;
        templates = null;
        videos = "${home}/Videos";

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${home}/Pictures/Screenshots";
        };
      };
    };
  };
}
