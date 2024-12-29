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
  symlinkJoin,
  ...
}: let
  name = "snapraid-btrfs";
  deps = with pkgs; [coreutils gnugrep gawk gnused snapraid snapper];
  script =
    (
      writeScriptBin name
      (builtins.readFile ((fetchFromGitHub {
          # https://github.com/automorphism88/snapraid-btrfs/pull/34
          owner = "D34DC3N73R";
          repo = "snapraid-btrfs";
          rev = "ea9a1cfbfbe1cefcae9c038e1a4962d4bc2de843";
          sha256 = "+UCBGlGFqRKgFjCt1GdOSxaayTONfwisxdnZEwxOnSY=";
        })
        + "/snapraid-btrfs"))
    )
    .overrideAttrs (old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });
in
  symlinkJoin {
    inherit name;
    paths = [script] ++ deps;
    buildInputs = with pkgs; [makeWrapper];
    postBuild = "wrapProgram $out/bin/${name} --set PATH $out/bin";
  }
