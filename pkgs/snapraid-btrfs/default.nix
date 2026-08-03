{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  writeScriptBin,
  symlinkJoin,
  ...
}:
let
  name = "snapraid-btrfs";
  deps = with pkgs; [
    coreutils
    gnugrep
    gawk
    gnused
    snapraid
    snapper
  ];
  script =
    (writeScriptBin name (
      builtins.readFile (
        (fetchFromGitHub {
          # https://github.com/automorphism88/snapraid-btrfs/pull/34
          owner = "D34DC3N73R";
          repo = "snapraid-btrfs";
          rev = "a43e9a40773772b881b1450edfef28c9937f5f27";
          sha256 = "sha256-zOFc1/H2hgcZMeGUnLvuWL+SFvE5kvekm0F/dvhakWI=";
        })
        + "/snapraid-btrfs"
      )
    )).overrideAttrs
      (old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
in
symlinkJoin {
  inherit name;
  paths = [ script ] ++ deps;
  buildInputs = with pkgs; [ makeWrapper ];
  postBuild = "wrapProgram $out/bin/${name} --set PATH $out/bin";
}
