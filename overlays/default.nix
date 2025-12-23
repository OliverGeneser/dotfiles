{
  inputs,
  withSystemVencord,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [fira-go beekeeper-studio bun turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.5.2";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-Hsv42bIUmXqplUTR/ut/oM1GisToFzGmHe5kVrwz/+I=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.3.5";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
          hash = "sha256-cFHYapJK7+o+C5YhO1/Y95wHk/nK5lNCM+Yn5cPbRmk=";
        };
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (final: prev: {
        version = "1.0.15";

        vendorHash = "sha256-tBO21IgUczwMgrEyV7scV3YTY898lYHASaLeXqvBopU=";

        src = prev.src.override {
          rev = "v${final.version}";
          hash = "sha256-c4RtEqMCpRgr4p6STWrRv7+UIA11WySTNhyvkLgzRso=";
        };
      });
    };

    fira-go = self: super: {
      fira-go = super.fira-go.overrideAttrs (final: prev: {
        src = super.fetchzip {
          url = "https://carrois.com/downloads/FiraGO/Download_Folder_FiraGO_${
            super.lib.replaceStrings ["."] [""] prev.version
          }.zip";
          hash = "sha256-+lw4dh7G/Xv3pzGXdMUl9xNc2Nk7wUOAh+lq3K1LrXs=";
          stripRoot = false;
        };
      });
    };
  };
}
