{stdenv, ...}:
stdenv.mkDerivation {
  pname = "lo-res";
  version = "0.1.0";

  src = ./LoRes;

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -R $src $out/share/fonts/truetype/
  '';
}
