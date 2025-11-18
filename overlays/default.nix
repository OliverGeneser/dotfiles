{
  inputs,
  withSystemVencord,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun turbo-unwrapped turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.4.11";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-yTQiVhyq0w2JvxMaSoUegocHZXq4zRVZR1yxQVn+bPQ=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.3.2";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
          hash = "sha256-DLVqRIS9d2Sj7vm55nq0V4QJgSh7RnlJdNHmYSy/Zwk=";
        };
      });
    };

    turbo-unwrapped = self: super: {
      turbo-unwrapped = super.turbo-unwrapped.overrideAttrs (final: prev: {
        version = "2.6.1";

        src = super.fetchFromGitHub {
          owner = "vercel";
          repo = "turborepo";
          tag = "v2.6.1";
          hash = "sha256-NQjN3u+xTQkU9cenBTHRwGyMsy8Sm1xbHckaq/DYHJk=";
        };
        cargoDeps = self.pkgs.rustPlatform.importCargoLock {
          lockFile = final.src + "/Cargo.lock";
          allowBuiltinFetchGit = true;
        };
        cargoHash = null;
      });

      turbo = super.turbo.override {
        turbo-unwrapped = self.turbo-unwrapped;
      };
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
  };
}
