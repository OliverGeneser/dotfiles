{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./obs.nix
    ./rnnoise.nix
    ./jellyfin.nix
    ./audacity.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol
    helvum

    # audio
    amberol

    # images
    loupe
  ];
}
