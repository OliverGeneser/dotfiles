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
      turso-cli
    ];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (
        final: prev: {
          version = "5.8.1";

          src = super.fetchurl {
            url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
            hash = "sha256-e5y7uBzdbDSUQKpxRjho+2kU3wx23spdSv1PwmJ30gA=";
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
          version = "1.0.26";

          vendorHash = "sha256-4OIJVL3N2mWOw7ZDP4xFCxa9zmUTPCA8N79TVoi1lys=";

          src = prev.src.override {
            rev = "v${final.version}";
            hash = "sha256-M7bYt5eH+beUMQYh/dFhEALot6MRdfc2vH0b9iEvhqc=";
          };
        }
      );
    };
  };
}
