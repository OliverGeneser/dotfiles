{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./browsers/helium.nix
    ./browsers/mullvad.nix
    ./browsers/zen.nix
    # ./communication/element.nix
    ./communication/vesktop.nix
    ./design
    ./media
    ./gtk.nix
    ./office
    ./qt.nix
    ./vicinae
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    tutanota-desktop
    telegram-desktop

    qalculate-qt
    gnome-control-center
    gnome-disk-utility

    meld

    infisical

    overskride
    resources
    wineWow64Packages.wayland

    zotero
  ];

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-dark";
  };
}
