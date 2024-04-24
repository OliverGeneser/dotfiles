{
  config,
  lib,
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
          "video/mp4" = ["io.github.celluloid_player.Celluloid.desktop"];
          "video/quicktime" = ["io.github.celluloid_player.Celluloid.desktop"];
          "video/webm" = ["io.github.celluloid_player.Celluloid.desktop"];
          "image/gif" = ["org.gnome.Loupe.desktop"];
          "image/png" = ["org.gnome.Loupe.desktop"];
          "image/jpg" = ["org.gnome.Loupe.desktop"];
          "image/jpeg" = ["org.gnome.Loupe.desktop"];
        };
        defaultApplications = {
          "application/x-extension-htm" = "mullvad-browser";
          "application/x-extension-html" = "mullvad-browser";
          "application/x-extension-shtml" = "mullvad-browser";
          "application/x-extension-xht" = "mullvad-browser";
          "application/x-extension-xhtml" = "mullvad-browser";
          "application/xhtml+xml" = "mullvad-browser";
          "text/html" = "mullvad-browser";
          "x-scheme-handler/about" = "mullvad-browser";
          "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
          "x-scheme-handler/ftp" = "mullvad-browser";
          "x-scheme-handler/http" = "mullvad-browser";
          "x-scheme-handler/https" = "mullvad-browser";
          "x-scheme-handler/unknown" = "mullvad-browser";

          "audio/*" = ["mpv.desktop"];
          "video/*" = ["org.gnome.Totem.dekstop"];
          "video/mp4" = ["org.gnome.Totem.dekstop"];
          "image/*" = ["org.gnome.loupe.desktop"];
          "image/png" = ["org.gnome.loupe.desktop"];
          "image/jpg" = ["org.gnome.loupe.desktop"];
          "application/json" = ["gnome-text-editor.desktop"];
          "application/pdf" = "mullvad-browser";
          "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
          "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
          "application/toml" = "org.gnome.TextEditor.desktop";
          "text/plain" = "org.gnome.TextEditor.desktop";
        };
      };

      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        };
      };
    };
  };
}
