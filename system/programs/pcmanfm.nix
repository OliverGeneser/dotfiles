{pkgs, ...}: {
  services = {
    udisks2.enable = true;

    # Mount, trash, and other functionalities
    gvfs.enable = true;

    # Thumbnail support for images
    tumbler.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      pcmanfm
      ffmpegthumbnailer # thumbnails
    ];
  };
}
