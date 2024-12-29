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
  writeTextFile,
  ...
}: let
  name = "snapraid-btrfs-runner";

  config = writeTextFile {
    name = "snapraid-btrfs-runner.conf";
    text = ''
      [snapraid-btrfs]
      ; path to the snapraid-btrfs executable (e.g. /usr/bin/snapraid-btrfs)
      executable = ${pkgs.custom.snapraid-btrfs}/bin/snapraid-btrfs
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
      executable = ${pkgs.snapper}/bin/snapper

      [snapraid]
      ; path to the snapraid executable (e.g. /usr/bin/snapraid)
      executable = ${pkgs.snapraid}/bin/snapraid
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

      [scrub]
      ; set to true to run scrub after sync
      enabled = true
      ; plan can be 0-100 percent, new, bad, or full
      plan = 12
      ; only used for percent scrub plan
      older-than = 10
    '';
    destination = "/etc/snapraid-btrfs-runner.conf";
  };
in
  stdenv.mkDerivation {
    pname = name;
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "OliverGeneser";
      repo = "snapraid-btrfs-runner";
      rev = "afb83c67c61fdf3769aab95dba6385184066e119";
      sha256 = "M8LXxsc7jEn5GsiXAKykmFUgsij2aOIenw1Dx+/5Rww=";
    };

    buildInputs = with pkgs; [python311 snapraid pkgs.custom.snapraid-btrfs snapper makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 snapraid-btrfs-runner.py $out/bin/${name}
      wrapProgram $out/bin/${name} --add-flags '-c ${config}/etc/snapraid-btrfs-runner.conf' --set PATH $out/bin
    '';

    meta = with lib; {
      description = "A tool to run SnapRAID with Btrfs support.";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  }
