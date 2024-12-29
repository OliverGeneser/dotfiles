{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,
  # The namespace used for your flake, defaulting to "internal" if not set.
  namespace,
  # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  stdenv,
  fetchFromGitHub,
  writeScriptBin,
  ...
}:
stdenv.mkDerivation {
  pname = "snapraid-btrfs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "automorphism88";
    repo = "snapraid-btrfs";
    rev = "6492a45ad55c389c0301075dcc8bc8784ef3e274";
    sha256 = "YPkKjlx7j7yjTWReAvgaFNz6dFxVIcaN9to2cDfmovU=";
  };

  buildInputs = with pkgs; [coreutils gnugrep gawk gnused snapraid snapper];

  installPhase = ''
    mkdir -p $out/bin
    cp snapraid-btrfs $out/bin
  '';

  meta = with lib; {
    description = "A tool to manage SnapRAID with Btrfs support.";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
