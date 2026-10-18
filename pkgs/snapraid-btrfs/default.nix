{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnugrep,
  gawk,
  gnused,
  snapraid,
  snapper,
}:
let
  runtimeDeps = [
    bash
    coreutils
    gnugrep
    gawk
    gnused
    snapraid
    snapper
  ];
in
stdenv.mkDerivation {
  pname = "snapraid-btrfs";
  version = "0.14.1+git-a43e9a4";

  src = fetchFromGitHub {
    # https://github.com/automorphism88/snapraid-btrfs/pull/34
    owner = "D34DC3N73R";
    repo = "snapraid-btrfs";
    rev = "a43e9a40773772b881b1450edfef28c9937f5f27";
    sha256 = "sha256-zOFc1/H2hgcZMeGUnLvuWL+SFvE5kvekm0F/dvhakWI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 snapraid-btrfs $out/bin/snapraid-btrfs
    # Upstream shebang is "#!/bin/bash -" which does not exist on NixOS
    # (/bin/bash is missing, only /bin/sh and /usr/bin/env exist).
    # patchShebangs silently skips it when bash is not in HOST_PATH
    # (strictDeps + empty buildInputs), so rewrite it explicitly.
    substituteInPlace $out/bin/snapraid-btrfs \
      --replace-fail '#!/bin/bash' '#!${lib.getExe bash}'
    wrapProgram $out/bin/snapraid-btrfs \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Btrfs snapshot management for SnapRAID";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
