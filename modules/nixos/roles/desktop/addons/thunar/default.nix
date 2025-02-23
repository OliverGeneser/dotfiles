{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.desktop.addons.thunar;
in {
  options.roles.desktop.addons.thunar = with types; {
    enable = mkBoolOpt false "Whether to enable the thunar file manager.";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    programs.dconf.enable = true;

    environment = {
      systemPackages = with pkgs; [
        xfce.thunar
        xfce.thunar-volman
        xfce.thunar-archive-plugin
        xfce.thunar-media-tags-plugin

        xfce.tumbler # thumbnails
        ffmpegthumbnailer # thumbnails
      ];
    };
  };
}
