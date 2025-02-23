{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.addons.thunar;
in {
  options.desktops.addons.thunar = {
    enable = mkEnableOption "Enable thunar file manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin

      gvfs # Trash, removable & remote filesystems

      xfce.tumbler # thumbnails
      ffmpegthumbnailer # thumbnails
    ];
  };
}
