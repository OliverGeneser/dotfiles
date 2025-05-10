{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;

    # Sets up all the libraries to load
    libraries = with pkgs; [
      stdenv.cc.cc # commonly needed
      zlib # commonly needed
      openssl # commonly needed
    ];
  };
}
