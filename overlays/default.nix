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
      gitbutler
      linuxPackages_latest
      #lutris
      #reuse
      turbo-unwrapped
      turso-cli
      viddy
      voxtype
    ];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (
        final: prev: {
          version = "6.2.2";

          src = super.fetchurl {
            url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
            hash = "sha256-DKojiNqcHdVJREaXcmkFPADJowm3+JNonVjFaSguNjY=";
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

    gitbutler = self: super: {
      # Workaround for nixpkgs cargoSetupHook (2026-10) forcing system libs
      # (*_SYS_USE_PKG_CONFIG=1) while gitbutler 0.19.9 doesn't declare them
      # in buildInputs:
      # - `ld.bfd: cannot find -lsqlite3` in gitbutler-tauri link -> sqlite
      # - onig_sys build.rs: `Unable to find oniguruma in pkg-config` -> oniguruma
      # Same class as viddy/voxtype below. Drop once upstream fixes
      # pkgs/by-name/gi/gitbutler/package.nix.
      gitbutler = super.gitbutler.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          super.sqlite
          super.oniguruma
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

    lutris = self: super: {
      # Backport of nixpkgs 7f22afb ("lutris: drop gtk2", 2026-11-02), not yet
      # in nixos-unstable. gtk2 is marked broken pending removal
      # (https://github.com/NixOS/nixpkgs/issues/410814) and lutris' FHS env
      # was the only thing pulling it in. Filter by pname so the broken gtk2
      # derivation is never forced. Drop once nixos-unstable has the commit.
      lutris = super.lutris.override {
        buildFHSEnv =
          args:
          super.buildFHSEnv (
            args
            // {
              multiPkgs = pkgs: builtins.filter (p: (p.pname or "") != "gtk+") (args.multiPkgs pkgs);
            }
          );
      };
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

    reuse = self: super: {
      # Workaround for upstream nixpkgs bug (2026-10):
      # python reuse-6.2.0 fails with "failed to produce output path for
      # output 'man'". sphinx-hook.sh does `eval "__sphinxBuilders=($sphinxBuilders)"`
      # which only expands to the first element when sphinxBuilders is a bash
      # array (structuredAttrs), so the "man" builder never runs and $man is
      # never created. Using a string makes the eval split correctly into
      # both builders and matches the cached Hydra build.
      pythonPackagesExtensions = (super.pythonPackagesExtensions or [ ]) ++ [
        (py-self: py-super: {
          reuse = py-super.reuse.overrideAttrs (_: {
            sphinxBuilders = "html man";
          });
        })
      ];
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

    turbo-unwrapped = self: super: {
      # Workaround for nixpkgs cargoSetupHook (2026-10) forcing system libs
      # (ZSTD_SYS_USE_PKG_CONFIG=1, OPENSSL_NO_VENDOR=1, AWS_LC_SYS_USE_SYSTEM=1)
      # while turbo-unwrapped 2.11.7 declares no system deps. Provide them
      # until nixpkgs fixes pkgs/by-name/tu/turbo-unwrapped/package.nix.
      turbo-unwrapped = super.turbo-unwrapped.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          super.pkg-config
        ];
        buildInputs = (old.buildInputs or [ ]) ++ [
          super.zstd
          super.openssl
          super.aws-lc
        ];
      });
    };

    viddy = self: super: {
      # Workaround for nixpkgs cargoSetupHook forcing system sqlite
      # (LIBSQLITE3_SYS_USE_PKG_CONFIG=1) while viddy 1.3.1 declares no
      # buildInputs. Upstream needs pkg-config + sqlite; add them here until
      # nixpkgs fixes pkgs/by-name/vi/viddy/package.nix.
      viddy = super.viddy.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          super.pkg-config
        ];
        buildInputs = (old.buildInputs or [ ]) ++ [
          super.sqlite
        ];
      });
    };

    voxtype = self: super: {
      # Same class of fix as viddy: voxtype 1.1.1 links -lsqlite3 (via
      # rusqlite) but doesn't declare sqlite in buildInputs. The new
      # cargoSetupHook forces LIBSQLITE3_SYS_USE_PKG_CONFIG=1, so the link
      # fails without system sqlite.
      voxtype = super.voxtype.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          super.sqlite
        ];
      });
    };
  };
}
