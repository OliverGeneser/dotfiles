{
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) toString baseNameOf dirOf concatStringsSep;
  inherit (lib) assertMsg last init;

  file-name-regex = "(.*)\\.(.*)$";

  split-file-extension = file: let
    match = builtins.match file-name-regex file;
  in
    assert assertMsg (match != null) "File must have an extension to split."; match;

  has-any-file-extension = file: let
    match = builtins.match file-name-regex (toString file);
  in
    match != null;

  get-file-extension = file:
    if has-any-file-extension file
    then let
      match = builtins.match file-name-regex (toString file);
    in
      last match
    else "";

  has-file-extension = extension: file:
    if has-any-file-extension file
    then extension == get-file-extension file
    else false;

  get-file-name-without-extension = path: let
    file-name = baseNameOf path;
  in
    if has-any-file-extension file-name
    then concatStringsSep "" (init (split-file-extension file-name))
    else file-name;

  images = builtins.attrNames (builtins.readDir ./wallpapers);
  mkWallpaper = name: src: let
    fileName = builtins.baseNameOf src;
    pkg = pkgs.stdenvNoCC.mkDerivation {
      inherit name src;

      dontUnpack = true;

      installPhase = ''
        cp $src $out
      '';

      passthru = {inherit fileName;};
    };
  in
    pkg;
  names = builtins.map get-file-name-without-extension images;
  wallpapers =
    lib.foldl
    (acc: image: let
      # fileName = builtins.baseNameOf image;
      # lib.getFileName is a helper to get the basename of
      # the file and then take the name before the file extension.
      # eg. mywallpaper.png -> mywallpaper
      name = get-file-name-without-extension image;
    in
      acc // {"${name}" = mkWallpaper name (./wallpapers + "/${image}");})
    {}
    images;
  installTarget = "$out/share/wallpapers";
  installWallpapers =
    builtins.mapAttrs
    (name: wallpaper: ''
      cp ${wallpaper} ${installTarget}/${wallpaper.fileName}
    '')
    wallpapers;
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "wallpapers";
    src = ./wallpapers;

    installPhase = ''
      mkdir -p ${installTarget}

      find * -type f -mindepth 0 -maxdepth 0 -exec cp ./{} ${installTarget}/{} ';'
    '';

    passthru = {inherit names;} // wallpapers;
  }
