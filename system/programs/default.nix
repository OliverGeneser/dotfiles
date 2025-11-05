{
  imports = [
    ./home-manager.nix
    ./adb.nix
    # ./qt.nix
    # ./thunar.nix
    ./pcmanfm.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
  };
}
