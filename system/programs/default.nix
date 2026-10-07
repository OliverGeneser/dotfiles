{ pkgs, ... }: {
  imports = [
    ./home-manager.nix
    ./adb.nix
    ./android.nix
    ./pcmanfm.nix
    ./vicinae.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    gpu-screen-recorder.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
  ];
}
