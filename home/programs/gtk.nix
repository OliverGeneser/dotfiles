{
  lib,
  pkgs,
  config,
  ...
}: {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.theme = null;

    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
      name = "Papirus-Dark";
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".enable = lib.mkForce false;
}
