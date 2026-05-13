{
  inputs,
  withSystemVencord,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [
      beekeeper-studio
      bun
      openldap
      turso-cli
    ];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (
        final: prev: {
          version = "5.7.2";

          src = super.fetchurl {
            url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
            hash = "sha256-PYgNkEixbIDcUKfWzYCsB0CZ4HlP2G3WHiN2xxvO/mw=";
          };
        }
      );
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (
        final: prev: {
          version = "1.3.14";

          src = super.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
            hash = "sha256-lR7iruhV8IWVruxiJSJqKY0/6oOj3NZGXAnLzN9+hI8=";
          };
        }
      );
    };

    efitools = self: super: {
      efitools = super.efitools.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./patch-efitools.patch
        ];
      });
    };

    nvidia = self: super: {
      linuxPackages_latest = super.linuxPackages_latest.extend (
        lpFinal: lpPrev: {
          nvidiaPackages = lpPrev.nvidiaPackages // {
            beta = lpPrev.nvidiaPackages.beta // {
              open = lpPrev.nvidiaPackages.beta.open.overrideAttrs (old: {
                patches = (old.patches or [ ]) ++ [
                  ./patch-nvidia.patch
                ];
              });
            };
          };
        }
      );
    };

    openldap = self: super: {
      openldap = super.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (
        final: prev: {
          version = "1.0.24";

          vendorHash = "sha256-Cb4/KA9jfI/pNHbJqLWtm9oEXfMHGBS46J9o3lL4/Tk=";

          src = prev.src.override {
            rev = "v${final.version}";
            hash = "sha256-3fKEFK4zCeKEYfiBJ7so5pZ3ZQC2td80XKWN3GKFWLA=";
          };
        }
      );
    };
  };
}
