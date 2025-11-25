{
  appimageTools,
  fetchurl,
  pkgs,
  lib,
  ...
}: let
  name = "Helium Nightly";
  version = "0.6.7.1";
  hash = "sha256-fZTBNhaDk5EeYcxZDJ83tweMZqtEhd7ws8AFUcHjFLs=";
  filename = "helium-${version}-x86_64.AppImage";
in
  appimageTools.wrapType2 rec {
    pname = "helium";

    inherit version;

    src = fetchurl {
      inherit hash;
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${filename}";
    };

    extraInstallCommands = let
      contents = appimageTools.extract {inherit pname version src;};
    in ''
      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'

      cp -r ${contents}/usr/share/* $out/share/

      install -d $out/share/lib/${pname}
      cp -r ${contents}/opt/${pname}/locales $out/share/lib/${pname}/
    '';

    meta = {
      description = "Private, fast, and honest web browser (nightly builds)";
      homepage = "https://github.com/imputnet/${pname}";
      changelog = "https://github.com/imputnet/helium-linux/releases/tag/${version}";
      license = lib.licenses.gpl3;
      maintainers = ["Ev357" "Prinky"];
      platforms = ["x86_64-linux" "aarch64-linux"];
      mainProgram = pname;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
