{ pkgs, ... }:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./obs.nix
    ./jellyfin.nix
    ./audacity.nix
  ];

  services.easyeffects.enable = true;

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol

    # audio
    amberol

    # images
    loupe
  ];
}
