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
      linuxPackages_latest
      turso-cli
    ];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (
        final: prev: {
          version = "6.1.6";

          src = super.fetchurl {
            url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
            hash = "sha256-dQ4pI3rivUiNad2ZT/HcVpHTM1+av/n23vRTm/EwKzw=";
          };

          # 6.1.6 bundles musl duckdb bindings that auto-patchelf can't satisfy.
          # They are unused on glibc systems, so ignore the missing musl libc.
          autoPatchelfIgnoreMissingDeps = (prev.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
            "libc.musl-x86_64.so.1"
          ];
        }
      );
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (
        final: prev: {
          version = "1.4.4";

          src = super.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
            hash = "sha256-v4zL+ysLgBWeD5ptFcVTF63YB3U028YTCj7bUvzLOVw=";
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

    linuxPackages_latest = self: super: {
      linuxPackages_latest = super.linuxPackages_latest.extend (
        _: lpprev: {
          ddcci-driver = lpprev.ddcci-driver.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              # allows detection even if monitor does not report itself as such
              "${self}/pkgs/ddcci-fix-missing-tags.patch"
              # retry core device detection so brightness works from boot
              # instead of only after a manual module reload (DDC/CI isn't
              # responsive yet when the udev rule instantiates the device)
              "${self}/pkgs/ddcci-probe-retry.patch"
            ];
          });
        }
      );
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
          version = "1.0.34";

          vendorHash = "sha256-wutbVEWWoTdgwtG6IXgCYEGn/rdmaPbLGcFeCTS2VNE=";

          src = prev.src.override {
            tag = "v${final.version}";
            hash = "sha256-cMEFInZqQOIWrfZVE7D/csdelMk7OkVSZl8MPhW7Y9I=";
          };
        }
      );
    };
  };
}
