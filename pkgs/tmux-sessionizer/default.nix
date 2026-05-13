{
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "tmux-sessionizer";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 tmux-sessionizer.sh $out/bin/tmux-sessionizer
  '';

  propagatedBuildInputs = with pkgs; [
    tmux
    coreutils
    fzf
  ];
}
