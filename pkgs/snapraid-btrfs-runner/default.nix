{
  lib,
  stdenv,
  fetchFromGitHub,
  writeTextFile,
  makeWrapper,
  python3,
  snapraid,
  snapper,
  signal-cli,
  snapraid-btrfs,
}:
let
  name = "snapraid-btrfs-runner";
  src = fetchFromGitHub {
    owner = "OliverGeneser";
    repo = "snapraid-btrfs-runner";
    rev = "204c160cc974a2b40dcd93ced9c1199eced1c7d2";
    sha256 = "sha256-jiFekEv1hz6eqgSWY8T17Z09UmRhvHsYhGnkje6xfgg=";
  };
  config = writeTextFile {
    name = "snapraid-btrfs-runner.conf";
    text = ''
      [snapraid-btrfs]
      ; path to the snapraid-btrfs executable (e.g. /usr/bin/snapraid-btrfs)
      executable = ${snapraid-btrfs}/bin/snapraid-btrfs
      ; optional: specify snapper-configs and/or snapper-configs-file as specified in snapraid-btrfs
      ; only one instance of each can be specified in this config
      snapper-configs =
      snapper-configs-file =
      ; specify whether snapraid-btrfs should run the pool command after the sync, and optionally specify pool-dir
      pool = false
      pool-dir =
      ; specify whether snapraid-btrfs-runner should automatically clean up all but the last snapraid-btrfs sync snapshot after a successful sync
      cleanup = true

      [snapper]
      ; path to snapper executable (e.g. /usr/bin/snapper)
      executable = ${snapper}/bin/snapper

      [snapraid]
      ; path to the snapraid executable (e.g. /usr/bin/snapraid)
      executable = ${snapraid}/bin/snapraid
      ; path to the snapraid config to be used
      config = /etc/snapraid.conf
      ; abort operation if there are more deletes than this, set to -1 to disable
      deletethreshold = 40
      ; if you want touch to be ran each time
      touch = false

      [logging]
      ; logfile to write to, leave empty to disable
      file =
      ; maximum logfile size in KiB, leave empty for infinite
      maxsize = 5000

      [email]
      ; when to send an email, comma-separated list of [success, error]
      sendon = success,error
      ; set to false to get full programm output via email
      short = true
      subject = [SnapRAID] Status Report:
      from =
      to =
      ; maximum email size in KiB
      maxsize = 500

      [smtp]
      host =
      ; leave empty for default port
      port =
      ; set to "true" to activate
      ssl = false
      tls = false
      user =
      password =

      [signal]
      enabled = true
      sendon = success,error
      ; path to the signal-cli executable (e.g. /usr/bin/signal-cli)
      executable = ${signal-cli}/bin/signal-cli
      config = /home/nixos/.local/share/signal-cli
      chatid = TO+DykH3guaqDHrFpJzM1QUQzSAfqBsEIgwVKrP74rQ=

      [scrub]
      ; set to true to run scrub after sync
      enabled = true
      ; plan can be 0-100 percent, new, bad, or full
      plan = 12
      ; only used for percent scrub plan
      older-than = 10
    '';
    destination = "/etc/${name}";
  };

  runtimeDeps = [
    python3
    snapraid
    snapper
    signal-cli
    snapraid-btrfs
  ];
in
stdenv.mkDerivation {
  inherit name src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 snapraid-btrfs-runner.py $out/bin/${name}
    # Upstream shebang is "#!/usr/bin/env python3". It happens to work on
    # NixOS (because /usr/bin/env exists), but don't rely on PATH lookup.
    # Point directly at the nix python instead.
    substituteInPlace $out/bin/${name} \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe python3}'
    # Keep a copy of the default config in the output for discoverability.
    install -Dm644 ${config}/etc/${name} $out/etc/${name}
    wrapProgram $out/bin/${name} \
      --add-flags "-c ${config}/etc/${name}" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Runner for snapraid-btrfs (diff/sync/scrub with notifications)";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
