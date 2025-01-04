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
  symlinkJoin,
  fetchFromGitHub,
  writeScriptBin,
  writeTextFile,
  ...
}: let
  name = "snapraid-btrfs-runner";
  deps = with pkgs; with pkgs.custom; [python311 config snapraid snapraid-btrfs snapper];
  src = fetchFromGitHub {
    owner = "OliverGeneser";
    repo = "snapraid-btrfs-runner";
    rev = "214f7d195fa0822347324ce0b4a789e0daab7b82";
    sha256 = "caMD6jIuIMRaD8MPZl/qLpZo5EX1Q3qJHNJD+rhiYeA=";
  };
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

      [signal]
      enabled = true
      sendon = success,error
      ; path to the signal-cli executable (e.g. /usr/bin/signal-cli)
      executable = ${pkgs.signal-cli}/bin/signal-cli
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
  script =
    (
      writeScriptBin name
      (builtins.readFile (src + "/snapraid-btrfs-runner.py"))
    )
    .overrideAttrs (old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });
in
  symlinkJoin {
    inherit name;
    paths = [script] ++ deps;
    buildInputs = with pkgs; [makeWrapper python311];
    postBuild = "wrapProgram $out/bin/${name} --add-flags '-c ${config}/etc/snapraid-btrfs-runner' --set PATH $out/bin";
  }
