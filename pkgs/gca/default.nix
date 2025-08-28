{
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "gca";
  version = "0.4.0";

  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    install -m755 gca.sh $out/bin/gca
  '';
}
