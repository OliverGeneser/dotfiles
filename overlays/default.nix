{
  inputs,
  withSystemVencord,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun turso-cli linuxPackages_latest];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.4.12";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-mz4CYCdbnIJFC94EwvBiq0NuCYqLRLPCIShlg4KEZKM=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.3.4";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
          hash = "sha256-M8aZYEno036LgVlZsUsF5bb0lhITUr8RuufQRxk8KL8=";
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

    linuxPackages_latest = self: super: {
      linuxPackages_latest = super.linuxPackages_latest.extend (lpSelf: lpSuper: {
        xpad-noone = lpSuper.xpad-noone.overrideAttrs (final: prev: {
          patches = [
            # https://github.com/medusalix/xpad-noone/pull/9
            (super.fetchpatch2 {
              name = "remove-usage-of-deprecated-ida-simple-xx-api.patch";
              url = "https://github.com/medusalix/xpad-noone/commit/e0f6ad5f2fabd5f8e74796a87154c92c8e9b6068.patch";
              hash = "sha256-7Ye/rd51RpzThgts8R5RT0CRVvx5bKmy5i0KPidic30=";
            })
          ];
        });
      });
    };
  };
}
