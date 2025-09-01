{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # ./anyrun
    ./browsers/chromium.nix
    ./browsers/mullvad.nix
    ./browsers/zen.nix
    ./communication/element.nix
    ./communication/vesktop.nix
    ./design
    ./media
    ./gtk.nix
    ./office
    ./qt.nix
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    tutanota-desktop
    tdesktop

    qalculate-qt
    gnome-control-center
    gnome-disk-utility

    meld

    infisical

    overskride
    resources
    wineWowPackages.wayland

    zotero
  ];

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-dark";
  };
}
