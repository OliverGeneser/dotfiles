{pkgs, ...}: {
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
      zlib # commonly needed
      openssl # commonly needed
    ];
  };
}
