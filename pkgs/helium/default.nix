{pkgs, ...}: let
  pname = "helium";
  version = "0.4.12.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.4.12.1/helium-0.4.12.1-x86_64.AppImage";
    hash = "sha256-Za1erduSuuWvfrV/oggSz3ttj79SVV5g1CdXtlWfanU=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    pkgs = pkgs;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share

      # unless linked, the binary is placed in $out/bin/helium-someVersion
      # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    '';

    extraBwrapArgs = [
      "--bind-try /etc/nixos/ /etc/nixos/"
    ];

    # vscode likes to kill the parent so that the
    # gui application isn't attached to the terminal session
    dieWithParent = false;

    extraPkgs = pkgs:
      with pkgs; [
        unzip
        autoPatchelfHook
        asar
        # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
        (buildPackages.wrapGAppsHook.override {inherit (buildPackages) makeWrapper;})
      ];
  }
