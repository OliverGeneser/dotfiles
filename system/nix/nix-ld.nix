{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;

    # Sets up all the libraries to load
    libraries = with pkgs; [
      stdenv.cc.cc # commonly needed
      stdenv.cc.cc.lib # commonly needed
      libGL
      glib
      libsm
      libice
      libx11
      zlib # commonly needed
      openssl # commonly needed

      # needed for android emulator
      pulseaudio
      nss
      nspr
      expat
      libbsd
      libdrm
      libxcb
      libXi
      libXext
      libxkbfile
      libpng
    ];
  };
}
