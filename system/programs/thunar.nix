{ pkgs, ... }: {
  services.udisks2.enable = true;

  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  # Mount, trash, and other functionalities
  services.gvfs.enable = true;

  # Thumbnail support for images
  services.tumbler.enable = true;

  environment = {
    systemPackages = with pkgs; [
      ffmpegthumbnailer # thumbnails
    ];
  };
}
