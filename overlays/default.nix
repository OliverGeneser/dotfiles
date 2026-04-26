{
  inputs,
  withSystemVencord,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun efitools openldap turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.6.5";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-JQs/B2CkwUuVBWgn+eJCokE3wWNrQzl8nj8Rd1UcCgk=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.3.13";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
          hash = "sha256-ecB3H6i5LDOq5B4VoODTB+qZ0OLwAxfHHGxTI3p44lo=";
        };
      });
    };

    efitools = self: super: {
      efitools = super.efitools.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ./patch-efitools.patch
          ];
      });
    };

    nvidia = self: super: {
      linuxPackages_latest = super.linuxPackages_latest.extend (lpFinal: lpPrev: {
        nvidiaPackages =
          lpPrev.nvidiaPackages
          // {
            beta =
              lpPrev.nvidiaPackages.beta
              // {
                open = lpPrev.nvidiaPackages.beta.open.overrideAttrs (old: {
                  patches =
                    (old.patches or [])
                    ++ [
                      ./patch-nvidia.patch
                    ];
                });
              };
          };
      });
    };

    openldap = self: super: {
      openldap = super.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (final: prev: {
        version = "1.0.20";

        vendorHash = "sha256-Cb4/KA9jfI/pNHbJqLWtm9oEXfMHGBS46J9o3lL4/Tk=";

        src = prev.src.override {
          rev = "v${final.version}";
          hash = "sha256-Vby81LYVEqysUmPU1P5d+VEME/SVYch14m1Mj7YvOXc=";
        };
      });
    };
  };
}
