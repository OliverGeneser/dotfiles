{pkgs, ...}: {
  programs = {
    appimage.enable = true;
    appimage.binfmt = true;
  };
}
