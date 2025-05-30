{pkgs, ...}: {
  services.udisks2.enable = true;

  # Mount, trash, and other functionalities
  services.gvfs.enable = true;

  # Thumbnail support for images
  services.tumbler.enable = true;

  environment = {
    systemPackages = with pkgs; [
      pcmanfm
      ffmpegthumbnailer # thumbnails
    ];
  };
}
